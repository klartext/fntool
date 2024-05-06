(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)


(* generate the new filename for prepending/inserting from property-string *)
let get_newname_from_propstring select (fileinfo : Fileinfo.fileinfo) propstring =
  match select with
    | `Prepend -> Filename.concat fileinfo.fni.dirname (propstring ^ "_" ^ fileinfo.fni.basename)
    | `Insert  -> Filename.concat fileinfo.fni.dirname (fileinfo.fni.chopped_basename ^ "." ^ propstring ^ fileinfo.fni.extension)
    | `Replace -> propstring


(* ------------------------------------------------ *)
let filerename rnmode mappinglist_fileinfo_prperty =

  let namecreator = get_newname_from_propstring rnmode in

  let renamer (fileinfo, propname) =
    let newname = namecreator fileinfo propname in
    Fswrite.do_rename fileinfo newname
  in
    List.iter renamer mappinglist_fileinfo_prperty





let prtstuff cwd fn fndn ddn newbase = Printf.printf "%40s %40s %40s %40s %40s\n" cwd fn fndn ddn newbase


