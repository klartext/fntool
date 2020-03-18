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
                extension:        string
              }


let getfilenameinfo fn =
  let file_basename = Filename.basename fn in
        {
          filename          =  fn;
          dirname           =  Filename.dirname fn;
          basename          =  file_basename;

          chopped_filename  =  Filename.remove_extension fn;
          chopped_basename  =  Filename.remove_extension file_basename;
          extension         =  Filename.extension file_basename
        }



type dt = { datetime: float }


type fileinfo = {
                  fni : fninfo;
                  digest: string option;
                  datetime: dt option;
                }


