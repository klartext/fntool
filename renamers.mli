val get_newname_from_propstring :
  [< `Dirname | `Insert | `Prepend | `Size ] ->
  Fileinfo.fileinfo -> string -> string
val do_rename : Fileinfo.fileinfo -> string -> unit
val filerename :
  [< `Dirname | `Insert | `Prepend | `Size ] ->
  (Fileinfo.fileinfo * string) list -> unit
val prtstuff : string -> string -> string -> string -> string -> unit
