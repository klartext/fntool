(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)


(* generate the new filename for prepending/inserting from property-string *)
let get_newname_from_propstring select (fileinfo : Fileinfo.fileinfo) propstring =
  match select with
    | `Prepend -> Filename.concat
                    fileinfo.dirname
                    (propstring ^ "_" ^ fileinfo.basename)
    | `Insert  -> Filename.concat
                    fileinfo.dirname
                    (fileinfo.chopped_basename ^ "." ^ propstring ^ fileinfo.extension)
    | `Replace -> propstring


(* ------------------------------------------------ *)
let filerename rnmode mappinglist_fileinfo_prperty only_gitcmd =

  let namecreator = get_newname_from_propstring rnmode in

  let renamer (fileinfo, propname) =
    let newname = namecreator fileinfo propname in

    if only_gitcmd
    then Fswrite.gitcmd_do_rename fileinfo newname
    else Fswrite.do_rename fileinfo newname
  in
    List.iter renamer mappinglist_fileinfo_prperty




(* ancient dev-helper *)
let prtstuff cwd fn fndn ddn newbase =
  Printf.printf "%40s %40s %40s %40s %40s\n" cwd fn fndn ddn newbase
