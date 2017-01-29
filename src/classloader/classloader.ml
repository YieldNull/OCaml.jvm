open VMError
open Core.Std

type t =
  { name : string;
    classes : (string, Jclass.t) Hashtbl.t; (* classes initialized *)
  }

let major_version = 52

let bootstrap_loader_name = "bootstrap"

let loaders = Hashtbl.create ~hashable:String.hashable ()

let create name =
  let loader =
    { name;
      classes = Hashtbl.create ~hashable:String.hashable ();
    } in
  Hashtbl.add_exn loaders ~key:name ~data:loader;
  loader

let get loader_name = Hashtbl.find_exn loaders loader_name

let find_class loader binary_name = Hashtbl.find loader.classes binary_name

let is_loader loader binary_name = Option.is_some @@ find_class loader binary_name

(* load a none array class from file System *)
let rec load_from_bytecode loader binary_name =
  let create_field field pool =
    let open! Bytecode.Field in
    let field_name = Poolbc.get_utf8 pool field.name_index in
    let field_access_flags = field.access_flags in
    let field_descriptor = Poolbc.get_utf8 pool field.descriptor_index in
    let field_attrs = field.attributes in
    let open! Jclass in
    { field_name; field_descriptor; field_access_flags; field_attrs}
  in
  let create_method mth pool =
    let open! Bytecode.Method in
    let method_name = Poolbc.get_utf8 pool mth.name_index in
    let method_access_flags = mth.access_flags in
    let method_descriptor = Poolbc.get_utf8 pool mth.descriptor_index in
    let method_attrs = mth.attributes in
    let open! Jclass in
    { method_name; method_descriptor; method_access_flags; method_attrs}
  in
  let is_interface access_flags =
    List.exists access_flags ~f:((=) Accflag.Interface)
  in
  let get_package name =
    let dot = String.rfindi name ~f:(fun _ c -> c = '.') in
    match dot with
    | Some i -> String.sub name ~pos:0 ~len:i
    | _ -> "."
  in
  (* check initiating loader *)
  if is_loader loader binary_name then raise LinkageError;
  let open! Bytecode in
  let bytecode = Bytecode.load binary_name in
  (* check major version *)
  if bytecode.major_version > major_version then raise UnsupportedClassVersionError;
  let pool = bytecode.constant_pool in
  let name = Poolbc.get_class pool bytecode.this_class in
  (* check class name *)
  if name <> binary_name then raise NoClassdefFoundError;
  let package = get_package name in
  let access_flags = bytecode.access_flags in
  let super_class  = match bytecode.super_class with
    | 0 -> if name <> "java/lang/Object" then (* Only Object has no super class *)
        raise (ClassFormatError "Invalid superclass index")
      else None
    | i -> let jclass = resolve_class loader package (Poolbc.get_class pool i) in
      (* interface's super class must be Object *)
      if is_interface access_flags && jclass.Jclass.name <> "java/lang/Object" then
        raise (ClassFormatError "Invalid superclass index");
      (* interface can not be super class *)
      if is_interface jclass.Jclass.access_flags then raise IncompatibleClassChangeError;
      (* super class can not be itself *)
      if name = jclass.Jclass.name then raise ClassCircularityError;
      Some jclass
  in
  let interfaces = List.map bytecode.interfaces ~f:(fun index ->
      let cls = Poolbc.get_class pool index in
      let jclass = resolve_class loader package cls in
      (* must be interface *)
      if not @@ is_interface jclass.Jclass.access_flags then raise IncompatibleClassChangeError;
      (* interface can not be itself *)
      if jclass.Jclass.name = name then raise ClassCircularityError;
      jclass
    )
  in
  let open! Jclass in
  let fields = List.map bytecode.fields ~f:(fun field -> create_field field pool) in
  let methods = List.map bytecode.methods ~f:(fun mth -> create_method mth pool) in
  let conspool = Array.create ~len:(Array.length pool) Byte8Placeholder in
  let attributes = bytecode.attributes in
  let jclass = { name; access_flags; super_class; interfaces;
                 fields; methods; conspool; attributes;
                 loader_name = loader.name; } (* record as defining loader*)
  in (* record as initiating loader*)
  Hashtbl.add_exn loader.classes ~key:binary_name ~data:jclass;
  jclass

(* Loading Using the Bootstrap Class Loader *)
and load_class loader binary_name =
  match find_class loader binary_name with
  | Some jclass -> jclass
  | None -> load_from_bytecode loader binary_name

and resolve_class loader referer_package binary_name =
  let tail = String.sub binary_name ~pos:1 ~len:(String.length binary_name - 1) in
  let jclass = match String.get binary_name 0 with
    | '[' -> let tp = String.get tail 0 in
      let primitive = ['B';'C';'D';'F';'I';'J';'S';'Z'] in
      (* if List.exists primitive ~f:((=) tp) then

      else *)
      resolve_class loader referer_package tail
    | 'L' -> load_class loader tail
    | _ -> load_class loader binary_name
  in
  let acc = jclass.Jclass.access_flags in
  if not (List.exists acc ~f:((=) Accflag.Public)) then begin
    let pkg_target = Jclass.package jclass.Jclass.name in
    if referer_package <> pkg_target then
      raise IllegalAccessError
  end;
  jclass
