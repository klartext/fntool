val get_newname_from_propstring :
  [< `Insert | `Prepend | `Replace ] -> Fileinfo.fileinfo -> string -> string
val filerename :
  [< `Insert | `Prepend | `Replace ] ->
  (Fileinfo.fileinfo * string) list -> unit
val prtstuff : string -> string -> string -> string -> string -> unit
