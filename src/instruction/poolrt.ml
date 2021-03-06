open Core
open VMError

include Types.InnPoolrt

let raise_index_error index =
  raise (ClassFormatError (sprintf "Invalid constant pool index %d" index))

let get pool index =
  let i = index - 1 in
  if i < Array.length pool then
    pool.(i)
  else
    raise_index_error index

let set pool index value =
  let i = index - 1 in
  if i < Array.length pool then
    pool.(i) <- value
  else
    raise_index_error index

let get_class poolrt index =
  match poolrt.(index) with
  | Class x -> x
  | _ -> raise VirtualMachineError

let get_method poolrt index =
  match poolrt.(index) with
  | Methodref x -> x
  | _ -> raise VirtualMachineError

let get_int poolrt index =
  match poolrt.(index) with
  | Integer x -> x
  | _ -> raise VirtualMachineError

let get_float poolrt index =
  match poolrt.(index) with
  | Float x -> x
  | _ -> raise VirtualMachineError

let get_long poolrt index =
  match poolrt.(index) with
  | Long x -> x
  | _ -> raise VirtualMachineError

let get_double poolrt index =
  match poolrt.(index) with
  | Double x -> x
  | _ -> raise VirtualMachineError

let get_string poolrt index =
  match poolrt.(index) with
  | String x -> x
  | _ -> raise VirtualMachineError
