type float32
type t = float32

external add : float32 -> float32 -> float32 = "float32_add"
external sub : float32 -> float32 -> float32 = "float32_sub"
external mul : float32 -> float32 -> float32 = "float32_mul"
external div : float32 -> float32 -> float32 = "float32_div"
external rem : float32 -> float32 -> float32 = "float32_rem"

external neg : float32 -> float32 = "float32_neg"
external equal : float32 -> float32 -> bool = "float32_equal"
external compare : float32 -> float32 -> int = "float32_compare"

external is_nan : float32 -> bool = "float32_is_nan"

external to_int32 : float32 -> int32 = "float32_to_int32"
external to_int64 : float32 -> int64 = "float32_to_int64"
external to_float64 : float32 -> float = "float32_to_float64"

external of_int32_bits : int32 -> float32 = "float32_of_int32_bits"
external of_int32 : int32 -> float32 = "float32_of_int32"
external of_int64 : int64 -> float32 = "float32_of_int64"
external of_float64 : float -> float32 = "float32_of_float64"

val one : float32

val zero : float32

val nan : float32

val positive_infinity : float32

val negative_infinity : float32

val (>=.) : float32 -> float32 -> bool

val (<=.) : float32 -> float32 -> bool

val (=.) : float32 -> float32 -> bool

val (<.) : float32 -> float32 -> bool

val (>.) : float32 -> float32 -> bool

val (<>.) : float32 -> float32 -> bool
