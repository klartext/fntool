(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

open Fileinfo


(* generate the new filename for prepending/inserting from property-string *)
let get_newname_from_propstring select fileinfo propstring =
  match select with
    | `Size
    | `Prepend -> Filename.concat fileinfo.fni.dirname (propstring ^ "_" ^ fileinfo.fni.basename)
    | `Insert  -> Filename.concat fileinfo.fni.dirname (fileinfo.fni.chopped_basename ^ "." ^ propstring ^ fileinfo.fni.extension)
    | `Dirname -> propstring


(* the actual renamer function which takes a HOF 'renamer' to get the new name *)
let do_rename fileinfo newname =
  if Sys.file_exists newname then (Printf.eprintf "target-filename exists already: could not rename %s to %s\n" fileinfo.fni.filename newname )
  else
    begin
      Printf.printf "renaming %s" fileinfo.fni.filename;
      Printf.printf " to %s\n" newname;
      flush stdout;
      Sys.rename fileinfo.fni.filename newname
    end


(* ------------------------------------------------ *)
let filerename rnmode mappinglist_fileinfo_prperty =

  let namecreator = get_newname_from_propstring rnmode in

  List.iter (fun (fileinfo, propname) -> let newname = namecreator fileinfo propname in
                                         do_rename fileinfo newname
            ) mappinglist_fileinfo_prperty





let prtstuff cwd fn fndn ddn newbase = Printf.printf "%40s %40s %40s %40s %40s\n" cwd fn fndn ddn newbase


