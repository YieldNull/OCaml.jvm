open Core

module T = struct
  type t = { name: string; descriptor : string; } [@@deriving sexp, compare]
  let hash t =
    (String.hash t.name) lxor (String.hash t.descriptor)
end
include T
include Hashable.Make(T)

let create name descriptor = { name; descriptor; }

let name t = t.name

let descriptor t = t.descriptor

let to_string t =
  sprintf "%s:%s" t.name t.descriptor

let hashtbl () = Hashtbl.create ~hashable:hashable ()

let cinit = { name = "<clinit>"; descriptor = "()V" }
