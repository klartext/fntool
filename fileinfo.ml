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


let create_mappinglist selection fileinfos =
  let extractor =
    match selection with
      | `date -> Tools.datestring
      | `md5  -> digest_of_file
      | `size -> size_of_file_as_string
  in
  List.map (fun fileinfo -> (fileinfo, extractor fileinfo.fni.filename)) fileinfos



(* --------------------------------------- *)
let getfileinfo propselector  fname =
  let dt  = if propselector = `date then None else None in (* add that later *)
  let md5 = if propselector = `md5 then Some (digest_of_file fname) else None in
  let sz  = if propselector = `size then Some (size_of_file_as_string fname) else None in

  { fni = getfilenameinfo fname; digest = md5; datetime = dt; sizestr = sz }





