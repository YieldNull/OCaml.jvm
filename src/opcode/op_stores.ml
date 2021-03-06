open Core
open Jvalue
open Frame

let op_istore frame =
  localvar_set frame (read_byte frame) (Int (get_int @@ stack_pop_exn frame))

let op_lstore frame =
  localvar_set frame (read_byte frame) (Long (get_long @@ stack_pop_exn frame))

let op_fstore frame =
  localvar_set frame (read_byte frame) (Float (get_float @@ stack_pop_exn frame))

let op_dstore frame =
  localvar_set frame (read_byte frame) (Double (get_double @@ stack_pop_exn frame))

let op_astore frame =
  localvar_set frame (read_byte frame) (get_reference_or_return_address @@ stack_pop_exn frame)

let op_istore_0 frame =
  localvar_set frame 0 (Int (get_int @@ stack_pop_exn frame))

let op_istore_1 frame =
  localvar_set frame 1 (Int (get_int @@ stack_pop_exn frame))

let op_istore_2 frame =
  localvar_set frame 2 (Int (get_int @@ stack_pop_exn frame))

let op_istore_3 frame =
  localvar_set frame 3 (Int (get_int @@ stack_pop_exn frame))

let op_lstore_0 frame =
  localvar_set frame 0 (Long (get_long @@ stack_pop_exn frame))

let op_lstore_1 frame =
  localvar_set frame 1 (Long (get_long @@ stack_pop_exn frame))

let op_lstore_2 frame =
  localvar_set frame 2 (Long (get_long @@ stack_pop_exn frame))

let op_lstore_3 frame =
  localvar_set frame 3 (Long (get_long @@ stack_pop_exn frame))

let op_fstore_0 frame =
  localvar_set frame 0 (Float (get_float @@ stack_pop_exn frame))

let op_fstore_1 frame =
  localvar_set frame 1 (Float (get_float @@ stack_pop_exn frame))

let op_fstore_2 frame =
  localvar_set frame 2 (Float (get_float @@ stack_pop_exn frame))

let op_fstore_3 frame =
  localvar_set frame 3 (Float (get_float @@ stack_pop_exn frame))

let op_dstore_0 frame =
  localvar_set frame 0 (Double (get_double @@ stack_pop_exn frame))

let op_dstore_1 frame =
  localvar_set frame 1 (Double (get_double @@ stack_pop_exn frame))

let op_dstore_2 frame =
  localvar_set frame 2 (Double (get_double @@ stack_pop_exn frame))

let op_dstore_3 frame =
  localvar_set frame 3 (Double (get_double @@ stack_pop_exn frame))

let op_astore_0 frame =
  localvar_set frame 0 (get_reference_or_return_address @@ stack_pop_exn frame)

let op_astore_1 frame =
  localvar_set frame 1 (get_reference_or_return_address @@ stack_pop_exn frame)

let op_astore_2 frame =
  localvar_set frame 2 (get_reference_or_return_address @@ stack_pop_exn frame)

let op_astore_3 frame =
  localvar_set frame 3 (get_reference_or_return_address @@ stack_pop_exn frame)

let op_iastore frame =
  let value = get_int @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Int value)

let op_lastore frame =
  let value = get_long @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Long value)

let op_fastore frame =
  let value = get_float @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Float value)

let op_dastore frame =
  let value = get_double @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Double value)

let op_aastore frame =
  let value = get_reference @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index value

let op_bastore frame =
  let value = get_int @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Byte (Int32.to_int_exn value))

let op_castore frame =
  let value = get_int @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Char (Int32.to_int_exn value))

let op_sastore frame =
  let value = get_int @@ stack_pop_exn frame in
  let index = get_int @@ stack_pop_exn frame in
  let arr = get_array @@ stack_pop_exn frame in
  Jarray.store arr index (Short (Int32.to_int_exn value))
