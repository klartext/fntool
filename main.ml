(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

exception Cli_option_exception

open Commontypes
open Cli



(* errmsg and exit *)
(* --------------- *)
let no_valid_option_was_selected errmsg =
  Printf.eprintf "%s - exiting now\n" errmsg;
  exit(1)


(* ----------------------------------------------------------------------------- *)

let () =
  begin
    try
      Cli.parse()
    with Cli_selection -> Printf.eprintf "Wrong parameter given for rename-mode\n"
  end;


(*
  Think about this ideas:
    - namealign-tool could be integrated too (option: -na)
    - option -ct for current time (instead of filetime)
*)


  (* set action and check on contradiction between move- and rename-switch *)
  (* --------------------------------------------------------------------- *)
  let action   = ref No_action in
  begin
    match opt.move, opt.rename with
      | true,  false -> action := Move
      | false, true  -> action := Rename
      | false, false -> no_valid_option_was_selected
                          "please select either -mv or -rn"
      | true,  true  -> no_valid_option_was_selected
                          "don't select both options: -mv and -rn"
  end;


  let use_time =
    if opt.year || opt.month || opt.day || opt.hour || opt.min || opt.sec || opt.usefloat
    then true
    else false
  in
  let use_md5  = if opt.md5 then true else false in
  let use_dirname = opt.dn in
  let use_size    = opt.size in

  let selected_prop =
    match use_size, use_time, use_md5, use_dirname with
      | false, false, false, true  -> Dirname
      | false, false, true,  false -> Md5
      | false, true,  false, false -> DateTime
      | true,  false,  false, false-> Size
      (* ------------------------------------------------- *)
      | false, false, false, false -> no_valid_option_was_selected
            "you have to select one of: time switch, md5 switch, dirname switch"
      (* ------------------------------------------------- *)
      | _                   -> no_valid_option_was_selected
                                "only use one option of: time, md5 or dirname"
      (* ------------------------------------------------- *)
  in


  (* set rename-mode default *)
  (* ----------------------- *)
  begin
    match opt.rnmode, selected_prop with
      | Default, Dirname -> opt.rnmode <- Prepend
      | Default, DateTime -> opt.rnmode <- Prepend
      | Default, Md5      -> opt.rnmode <- Insert
      | Default, Size     -> opt.rnmode <- Prepend
      | _,       _        -> () (* don't overwrite non-Defaults *)
  end;


  let files = List.filter Sys.file_exists opt.file_list in
  let sel, ign = List.partition Tools.is_not_directory files in

  (* filter filenames, depending on switches -ad and -md5 *)
  let filenames =
    match opt.allow_dir, use_md5 with
      | true,  false -> files (* dirs accepted *)
      | _            -> sel (* no dirs *)
  in

  (* if md5 and allow-dir selected, then print message about on ignored directories *)
  if use_md5 && opt.allow_dir && List.length ign > 0 then
  begin
    Printf.eprintf
      "Can't calculate checksums for directories, ignoring the following dirs:\n%!";
    List.iter ( fun fname -> Printf.eprintf "ignoring directory: %s\n%!" fname ) ign
  end;

  (* look up file-information and extract the property-string *)
  let selector =
    match selected_prop with
      | DateTime -> `date
      | Md5      -> `md5
      | Size     -> `size
      | Dirname  -> `dirname
  in
  let mappinglist = Fileinfo.create_mappinglist selector filenames in (* (fileinfo * extracted_property) list *)

  (* call the functions that do the renaming / moving *)
  (* append option is not implemented so far          *)
  begin
    match !action, selected_prop, opt.rnmode with
          (* --------------------------------- *)
          | Rename,  DateTime, Prepend   -> Renamers.filerename `Prepend mappinglist opt.gitcmd; exit 0
          | Rename,  DateTime, Insert    -> Renamers.filerename `Insert  mappinglist opt.gitcmd; exit 0
          | Rename,  DateTime, Append    -> (Printf.eprintf "Appending rename not supported for time switches\n%!"; exit 1)
          | Rename,  Md5,      Append    -> (Printf.eprintf "Appending rename not supported for md5\n%!"; exit 1)
          | Rename,  Md5,      Insert    -> Renamers.filerename `Insert  mappinglist opt.gitcmd; exit 0
          | Rename,  Md5,      Prepend   -> Renamers.filerename `Prepend mappinglist opt.gitcmd; exit 0
          | Rename,  Dirname,  Prepend   -> Renamers.filerename `Replace mappinglist opt.gitcmd; exit 0
          | Rename,  Size,     Prepend   -> Renamers.filerename `Prepend mappinglist opt.gitcmd; exit 0
          | Rename,  Size,     _         -> (Printf.eprintf "Size only supported to be prepended\n%!"; exit 1)
          (* --------------------------------- *)
          | Move,    DateTime, _         -> Movers.movefiles_to_dir mappinglist opt.gitcmd; exit 0
          (* --------------------------------- *)
          | Move,    Md5,      _         -> Movers.movefiles_to_dir mappinglist opt.gitcmd; exit 0
          | Move,    Size,     _         -> Movers.movefiles_to_dir mappinglist opt.gitcmd; exit 0
          | _,       Dirname,  _         -> no_valid_option_was_selected "-dn option only allowed with prepend-mode"
          | _,       _,        Default    -> () (* is unneded *)
          | No_action, _        , _       -> () (* is excluded already *)
          (* --------------------------------- *)
  end;

  Printf.eprintf "No available functionality has been seleted.\n%!"; exit 1 (* fallback *)
