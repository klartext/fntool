(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

open Commontypes

type opt_t = {
               mutable allow_dir        :  bool;          (*  -ad: allow dirs to be moved too *)
               mutable file_list        :  string list;    (* *)

               mutable year             :  bool;          (*  -ty:   YYYY                      *)
               mutable month            :  bool;          (*  -tmon: YYYY-MM                   *)
               mutable day              :  bool;          (*  -td:   YYYY-MM-DD                *)
               mutable hour             :  bool;          (*  -th:   YYYY-MM-DD_hh'h'          *)
               mutable min              :  bool;          (*  -tm:   YYYY-MM-DD_hh'h'mm'm'     *)
               mutable sec              :  bool;          (*  -ts:   YYYY-MM-DD_hh'h'mm'm'ss's *)
               mutable usefloat         :  bool;          (*  -tf: use float value of st_mtime *)

               mutable size             :  bool;          (*  -s: use size *)

               mutable md5              :  bool;          (*  -md5: *)

               mutable rename           :  bool;          (*  -rn rename *)
               mutable rnmode           :  rename_mode;   (*  -rnmode <sel>: mode of renaming of a file. Possible selections: 'p', 'i', 'a'  *)
               mutable move             :  bool;          (*  -m: move file *)

               mutable dn               :  bool;          (*  -dn: use dirname - all other cli-switches ignored*)

               mutable cwd              :  bool;          (*  -cwd: use all files of the current working dircetory *)
               mutable gitcmd           :  bool;          (*  -gitcmd: dont rename/move files (still create dirs), instead print 'git mv' commands *)
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

             size       = false;

             md5        = false;

             rename     = false;
             rnmode     = Default;

             move       = false;

             dn         = false;

             cwd        = false;
             gitcmd     = false;

           }



(* parse(): function to parse the command line *)
(* ------------------------------------------- *)
let parse () =
  let args_list =
    Arg.align [
                ("-ad",   Arg.Unit  (fun ()   -> opt.allow_dir <- true       ),        " allow dir to be moved too." );
                ("-md5",  Arg.Unit  (fun ()   -> opt.md5       <- true       ),        " use md5-sum of file." );
                ("-dn",   Arg.Unit  (fun ()   -> opt.dn        <- true         ),        " prepend current dirname to file / dir" );

                ("-ty",   Arg.Unit  (fun ()   -> opt.year      <- true       ),        " time year:    use file's last modification time as YYYY." );
                ("-tmon", Arg.Unit  (fun ()   -> opt.month     <- true       ),        " time month:   use file's last modification time as YYYY-MM." );
                ("-td",   Arg.Unit  (fun ()   -> opt.day       <- true       ),        " time day:     use file's last modification time as YYYY-MM-DD" );
                ("-th",   Arg.Unit  (fun ()   -> opt.hour      <- true       ),        " time hours:   use file's last modification time as YYYY-MM-DD_hh'h'" );
                ("-tm",   Arg.Unit  (fun ()   -> opt.min       <- true       ),        " time minutes: use file's last modification time as YYYY-MM-DD_hh'h'mm'm'" );
                ("-ts",   Arg.Unit  (fun ()   -> opt.sec       <- true       ),        " time seconds: use file's last modification time as YYYY-MM-DD_hh'h'mm'm'ss's'" );
                ("-tf",   Arg.Unit  (fun ()   -> opt.usefloat  <- true       ),        " time float:   use file's last modification time since unix epoche as float value (%f)" );

                ("-s",   Arg.Unit  (fun ()   -> opt.size  <- true            ),        " size: use filesize" );

                ("-rn",   Arg.Unit  (fun ()   -> opt.rename    <- true         ),        " renaming file" );

                ("-rnmode",  Arg.String  (fun select   -> opt.rnmode  <- match select with
                                                                                  | "p" -> Prepend
                                                                                  | "i" -> Insert
                                                                                  | _ -> raise Cli_selection),
                                                                 " rename-mode: p = prepend, i = insert before extension (default: prepend)." );
                (* ??does append mode make sense at all? Have no usecase in mind, where it might make sense!!
                ("-rnmode",  Arg.String  (fun select   -> opt.rnmode  <- match select with
                                                                                  | "p" -> Prepend
                                                                                  | "i" -> Insert
                                                                                  | "a" -> Append
                                                                                  | _ -> raise Cli_selection),
                                                                 " rename-mode: p = prepend, i = insert before extension, a = append (default: prepend)." );
                *)
                ("-mv",   Arg.Unit  (fun ()   -> opt.move      <- true         ),        " move file into a directory" );
                ("-gitcmd", Arg.Unit (fun ()   -> opt.gitcmd   <- true         ),        " no move/rename, instead print 'git mv' commands - dirs will still be created" );


              ]
  in
    Arg.parse args_list
      ( fun str -> opt.file_list <- str :: opt.file_list  )
      "Use \"fntool\" with the following options:"



