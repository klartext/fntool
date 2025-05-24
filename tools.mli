val date_of_file :
  ?month:bool ->
  ?day:bool ->
  ?hours:bool ->
  ?minutes:bool -> ?seconds:bool -> ?usefloat:bool -> string -> string
val datestring : string -> string
val is_regfile : string -> bool
val is_not_directory : string -> bool
val directdir : string -> string
val longestpath : string -> string -> string
val files_of_curdir : unit -> string list
