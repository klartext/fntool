(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

open Fileinfo


(* ------------------------------------------------ *)
let filerename rnmode rnwhat fninfos =
  let selected = List.filter (fun file -> Tools.is_regfile file.filename ) fninfos in (* filter: only regular files *)


  (* the actual renamer function which takes a HOF 'renamer' to get thenew name *)
  let do_rename renamer file =
    let newname = renamer file in

    if Sys.file_exists newname then (Printf.eprintf "target-filename exists already: could not rename %s to %s\n" file.filename newname )
    else
      begin
        Printf.printf "renaming %s" file.filename;
        Printf.printf " to %s\n" newname;
        flush stdout;
        Sys.rename file.filename newname
      end
  in

  let renamer_pre file = match rnmode, rnwhat with
    | `Insert,  `md5  -> Tools.get_insertname  file Tools.digest_of_file
    | `Prepend, `md5  -> Tools.get_prependname file Tools.digest_of_file
    | `Insert,  `date -> Tools.get_insertname  file Tools.datestring
    | `Prepend, `date -> Tools.get_prependname file Tools.datestring
  in

  let renamer = do_rename renamer_pre in

  List.iter renamer selected





let prtstuff cwd fn fndn ddn newbase = Printf.printf "%40s %40s %40s %40s %40s\n" cwd fn fndn ddn newbase


(* ------------------------------------------------------ *)
(* prepends the dirname in which the file/directory lives *)
(* works on files and dirs as well                        *)
(* ------------------------------------------------------ *)
let prependdirname filenames =
  let cwd = Unix.getcwd() in (* current working directory (full abspath) *)

  (*
  prtstuff "CWD" "FNAME" "FNDN" "DDN" "NEWBASE";
  *)

  List.iter ( fun fname ->
                           if Sys.file_exists fname then
                             begin

                               let fndn = Filename.dirname fname in (* filename-dirname (dirname o filename) *)

                               let usepath = Tools.longestpath cwd fndn in

                               let ddn   = Tools.directdir usepath in
                               let file_basename = Filename.basename fname in

                               let new_basename = if fndn = "." then ddn ^ "_" ^ file_basename else (Tools.directdir fndn) ^ "_" ^ file_basename in
                               let new_fullpath = if fndn = "." then new_basename else Filename.concat fndn new_basename in

                               Printf.printf "renaming: %s to %s\n" fname new_fullpath;
                               Sys.rename fname new_fullpath
                             end
                           else
                             Printf.eprintf "File %s does not exist!\n" fname
            ) filenames


