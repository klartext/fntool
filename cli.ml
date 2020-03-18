(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

open Commontypes

type opt_t = {
               mutable allow_dir        :  bool;          (*  -ad: allow dirs to be moved too *)
               mutable file_list        :  string list;    (* *)

               mutable year             :  bool;          (*  -ty: use file-date from st_mtime with year (yyyy) *)
               mutable month            :  bool;          (*  -tmon: use file-date with month *)
               mutable day              :  bool;          (*  -td: day use file-date with day *)
               mutable hour             :  bool;          (*  -th: hour of file-date too *)
               mutable min              :  bool;          (*  -tm: minutes of file-date too *)
               mutable sec              :  bool;          (*  -th: seconds of file-date too *)
               mutable usefloat         :  bool;          (*  -tf: use float value of st_mtime *)

               mutable md5              :  bool;          (*  -md5: *)

               mutable rename           :  bool;          (*  -rn rename *)
               mutable rnmode           :  rename_mode;   (*  -rnmode <sel>: mode of renaming of a file. Possible selections: 'p', 'i', 'a'  *)
               mutable move             :  bool;          (*  -m: move file *)

               mutable dn               :  bool;          (*  -dn: use dirname - all other cli-switches ignored*)

               mutable cwd              :  bool;          (*  -cwd: use all files of the current working dircetory *)
             }



(* the DEFAULT-settings for the program *)
(* ------------------------------------ *)
let opt =  {
             allow_dir = false;
             file_list  = [];

             year       = false;
             month      = false;
             day        = false;
             hour       = false;
             min        = false;
             sec        = false;
             usefloat   = false;

             md5        = false;

             rename     = false;
             rnmode     = Default;    (* "d": use default *)

             move       = false;

             dn         = false;

             cwd        = false;

           }



(* parse(): function to parse the command line *)
(* ------------------------------------------- *)
let parse () =
  let args_list =
    Arg.align [
                ("-ad",   Arg.Unit  (fun ()   -> opt.allow_dir <- true       ),        " allow dir to be moved too." );
                ("-md5",  Arg.Unit  (fun ()   -> opt.md5       <- true       ),        " use md5-sum of file." );

                ("-ty",   Arg.Unit  (fun ()   -> opt.year      <- true       ),        " year: prepend file-date inclduding year (st_mtime)." );
                ("-tmon", Arg.Unit  (fun ()   -> opt.month     <- true       ),        " month: prepend file-date inclduding month (st_mtime)." );
                ("-td",   Arg.Unit  (fun ()   -> opt.day       <- true       ),        " day: prepend file-date inclduding day (st_mtime)." );
                ("-th",   Arg.Unit  (fun ()   -> opt.hour      <- true       ),        " time: use hours of file-time (st_mtime) too." );
                ("-tm",   Arg.Unit  (fun ()   -> opt.min       <- true       ),        " time: use minutes of file-time (st_mtime) too." );
                ("-ts",   Arg.Unit  (fun ()   -> opt.sec       <- true       ),        " time: use seconds of file-time (st_mtime) too." );
                ("-tf",   Arg.Unit  (fun ()   -> opt.usefloat  <- true       ),        " time: use float of st.st_mtime (and no other date-/time-stuff)" );

                ("-rn",   Arg.Unit  (fun ()   -> opt.rename    <- true         ),        " renaming file" );
                ("-rnmode",  Arg.String  (fun select   -> opt.rnmode  <- match select with
                                                                                  | "p" -> Prepend
                                                                                  | "i" -> Insert
                                                                                  | "a" -> Append
                                                                                  | _ -> raise Cli_selection),
                                                                 " rename-mode: p = prepend, i = insert before extension, a = append (default: prepend)." );
                ("-mv",   Arg.Unit  (fun ()   -> opt.move      <- true         ),        " move file into a directory" );

                ("-dn",   Arg.Unit  (fun ()   -> opt.dn        <- true         ),        " use dirname" );

              ]
  in
    Arg.parse args_list
      ( fun str -> opt.file_list <- str :: opt.file_list  )
      "Use \"datedir-filemove\" following options:"



