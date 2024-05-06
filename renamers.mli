val filerename :
  [< `Insert | `Prepend | `Replace ] ->
  (Fileinfo.fileinfo * Fswrite.newname) list -> bool -> unit
