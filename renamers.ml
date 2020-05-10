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
    | `Prepend -> Filename.concat fileinfo.fni.dirname (propstring ^ "_" ^ fileinfo.fni.basename)
    | `Insert  -> Filename.concat fileinfo.fni.dirname (fileinfo.fni.chopped_basename ^ "." ^ propstring ^ fileinfo.fni.extension)


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

  (*
  let fileinfo_property_mapping = Tools.create_mappinglist rnwhat fileinfos in
  *)

  List.iter (fun (fileinfo, propname) -> let newname = namecreator fileinfo propname in
                                         do_rename fileinfo newname
            ) mappinglist_fileinfo_prperty





let prtstuff cwd fn fndn ddn newbase = Printf.printf "%40s %40s %40s %40s %40s\n" cwd fn fndn ddn newbase


(* ------------------------------------------------------ *)
(* prepends the dirname in which the file/directory lives *)
(* works on files and dirs as well                        *)
(* ------------------------------------------------------ *)
let create_prepend_dirname fname =
  let cwd = Unix.getcwd() in (* current working directory (full abspath) *)
  let fi = Fileinfo.getfilenameinfo fname in

  let fndn = fi.dirname in (* filename-dirname (dirname o filename) *)

  let usepath = Tools.longestpath cwd fndn in

  let ddn   = Tools.directdir usepath in
  let file_basename = fi.basename in

  let new_basename = if fndn = "." then ddn ^ "_" ^ file_basename else (Tools.directdir fndn) ^ "_" ^ file_basename in
  let new_fullpath = if fndn = "." then new_basename else Filename.concat fndn new_basename in

  new_fullpath



let prependdirname_single_file fileinfo =
  let fname = fileinfo.fni.filename in
  let cwd = Unix.getcwd() in (* current working directory (full abspath) *)
  let fi = Fileinfo.getfilenameinfo fname in

  if Sys.file_exists fname then
    begin
      let new_fullpath = create_prepend_dirname fileinfo.fni.filename in
      Printf.printf "renaming: %s to %s\n" fname new_fullpath;
      Sys.rename fname new_fullpath
    end
  else
   Printf.eprintf "File %s does not exist!\n" fname

let prependdirname fileinfos =
  List.iter prependdirname_single_file fileinfos

