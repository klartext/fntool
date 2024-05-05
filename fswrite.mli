type oldname = string
type newname = string
type dirname = string
val move_files_to_newdir : (oldname * dirname) list -> unit
val do_rename : Fileinfo.fileinfo -> newname -> unit
val gitcmd_move_files_to_newdir : (oldname * dirname) list -> unit
val gitcmd_do_rename : Fileinfo.fileinfo -> newname -> unit
