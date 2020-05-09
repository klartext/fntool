(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

open Fileinfo

(* --------------- *)
let movefiles_to_dir mappinglist =
  let sorted = List.sort ( fun item1 item2 -> compare (snd item1) (snd item2) ) mappinglist in (* sort by dirname *)
  let fnsorted = List.map (fun (fileinfo, dir) -> fileinfo.fni.filename, dir) sorted in
  Tools.move_files_to_newdir fnsorted


