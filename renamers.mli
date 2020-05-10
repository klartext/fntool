val get_newname_from_propstring :
  [< `Insert | `Prepend ] -> Fileinfo.fileinfo -> string -> string
val do_rename : Fileinfo.fileinfo -> string -> unit
val filerename :
  [< `Insert | `Prepend ] -> (Fileinfo.fileinfo * string) list -> unit
val prtstuff : string -> string -> string -> string -> string -> unit
val create_prepend_dirname : string -> string
val prependdirname_single_file : Fileinfo.fileinfo -> unit
val prependdirname : Fileinfo.fileinfo list -> unit
