(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

type fninfo = {
                filename:         string;
                dirname:          string;
                basename:         string;
                chopped_filename: string;
                chopped_basename: string;
                extension:        string;
              }


type dt = { datetime: float }


type fileinfo = {
                  fni : fninfo;
                  digest: string option;
                  datetime: dt option;
                  sizestr: string option;
                }


(* Helper functions *)
(* ================ *)
let size_of_file fname =
  let open Unix in
  let s = stat fname in
  s.st_size

let size_of_file_as_string fname = size_of_file fname |> string_of_int

let digest_of_file filename = Digest.to_hex (Digest.file filename)


(* ============================================ *)

let getfilenameinfo fn =
  let file_basename = Filename.basename fn in
        {
          filename          =  fn;
          dirname           =  Filename.dirname fn;
          basename          =  file_basename;

          chopped_filename  =  Filename.remove_extension fn;
          chopped_basename  =  Filename.remove_extension file_basename;
          extension         =  Filename.extension file_basename;
        }

let create_prepend_dirname fname =
  let cwd = Unix.getcwd() in (* current working directory (full abspath) *)
  let filenameinfo = getfilenameinfo fname in

  let fndn = filenameinfo.dirname in (* filename-dirname (dirname o filename) *)

  let usepath = Tools.longestpath cwd fndn in

  let ddn   = Tools.directdir usepath in
  let file_basename = filenameinfo.basename in

  let new_basename = if fndn = "." then ddn ^ "_" ^ file_basename else (Tools.directdir fndn) ^ "_" ^ file_basename in
  let new_fullpath = if fndn = "." then new_basename else Filename.concat fndn new_basename in

  new_fullpath




(* --------------------------------------- *)
let getfileinfo propselector  fname =
  let dt  = if propselector = `date then None else None in (* add that later *)
  let md5 = if propselector = `md5 then Some (digest_of_file fname) else None in
  let sz  = if propselector = `size then Some (size_of_file_as_string fname) else None in

  { fni = getfilenameinfo fname; digest = md5; datetime = dt; sizestr = sz }


let create_mappinglist selection filenames =
  let fileinfos = List.map (fun fn -> getfileinfo selection fn) filenames in
  let property_extractor =
    match selection with
      | `date -> Tools.datestring (* extracted property *)
      | `md5  -> digest_of_file (* extracted property *)
      | `size -> size_of_file_as_string (* extracted property *)
      | `dirname -> create_prepend_dirname (* complete relacement (newname), not only property *)
  in
  List.map (fun fileinfo -> (fileinfo, property_extractor fileinfo.fni.filename)) fileinfos




