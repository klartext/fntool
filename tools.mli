val date_of_file :
  ?month:bool ->
  ?day:bool ->
  ?hours:bool ->
  ?minutes:bool -> ?seconds:bool -> ?usefloat:bool -> string -> string
val digest_of_file : string -> string
val datestring : string -> string
val is_regfile : string -> bool
val create_dir_if_not_exists : string -> unit
val is_not_directory : string -> bool
val directdir : string -> string
val longestpath : string -> string -> string
val files_of_curdir : unit -> string list
val move_files_to_newdir : (string * string) list -> unit
