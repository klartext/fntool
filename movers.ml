(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

(* --------------- *)
let movefiles_to_dir mappinglist only_gitcmd =
  let sorted = List.sort ( fun item1 item2 -> compare (snd item1) (snd item2) ) mappinglist in (* sort by dirname *)
  let fnsorted = List.map (fun ((fileinfo : Fileinfo.fileinfo), dir) -> fileinfo.fni.filename, dir) sorted in

  if only_gitcmd
  then Fswrite.gitcmd_move_files_to_newdir fnsorted
  else Fswrite.move_files_to_newdir fnsorted


