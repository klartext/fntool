(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

(* --------------- *)
let movefiles_to_datedir files =
  let mappinglist = List.map (fun file -> (file, Tools.datestring file)) files in
  let sorted = List.sort ( fun item1 item2 -> compare (snd item1) (snd item2) ) mappinglist in (* sort by date *)
  Tools.move_file_to_newdir sorted


let movefiles_to_md5dir files =
  let mappinglist = List.map (fun file -> (file, Tools.digest_of_file file)) files in
  let sorted = List.sort ( fun item1 item2 -> compare (snd item1) (snd item2) ) mappinglist in (* sort by date *)
  Tools.move_file_to_newdir sorted


