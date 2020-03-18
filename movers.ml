(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

(* --------------- *)
let movefilestodatedir files =
  let mappinglist = List.map (fun file -> (file, Tools.datestring file)) files |> List.sort ( fun item1 item2 -> compare (snd item1) (snd item2) ) in
  Tools.move_file_to_newdir mappinglist

