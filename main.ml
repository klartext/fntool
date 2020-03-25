(*
  This source code is part of the program 'tfntool'

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
      | false, false -> no_valid_option_was_selected "please select either -mv or -rn"
      | true,  true  -> no_valid_option_was_selected "don't select both options: -mv and -rn"
  end;


  let use_time = if opt.year || opt.month || opt.day || opt.hour || opt.min || opt.sec || opt.usefloat then true else false in
  let use_md5  = if opt.md5 then true else false in
  let use_dirname = opt.dn in

  let selected_prop =
    match use_time, use_md5, use_dirname with
      | false, false, true  -> Dirname
      | false, true,  false -> Md5
      | true,  false, false -> DateTime
      (* ------------------------------------------------- *)
      | false, false, false -> no_valid_option_was_selected "you have to select one of: time switch, md5 switch, dirname switch"
      (* ------------------------------------------------- *)
      | _                   -> no_valid_option_was_selected "only use one option of: time, md5 or dirname"
      (* ------------------------------------------------- *)
  in


  (* set rename-mode default *)
  (* ----------------------- *)
  begin
    match opt.rnmode, selected_prop with
      | Default, Dirname -> opt.rnmode <- Prepend
      | Default, DateTime -> opt.rnmode <- Prepend
      | Default, Md5      -> opt.rnmode <- Insert
      | _,       _        -> () (* don't overwrite non-Defaults *)
  end;



  let sel, ign = List.partition Tools.is_not_directory opt.file_list in

  (* filter filenames, depending on switches -ad and -md5 *)
  let filenames = match opt.allow_dir, use_md5 with
    | true,  false -> opt.file_list (* dirs accepted *)
    | _            -> sel (* no dirs *)
  in

  (* if md5 and allow-dir selected, then print message about on ignored directories *)
  if use_md5 && opt.allow_dir && List.length ign > 0 then
  begin
    Printf.eprintf "Can't calculate checksums for directories, ignoring the following dirs:\n%!";
    List.iter ( fun fname -> Printf.eprintf "ignoring directory: %s\n%!" fname ) ign
  end;

  (* look up filename inofrmation *)
  let fninfos = List.map Fileinfo.getfilenameinfo filenames in

  (* call the functions that do the renaming / moving *)
  (* append option is not implemented so far          *)
  begin
    match !action, selected_prop, opt.rnmode with
          (* --------------------------------- *)
          | Rename,  DateTime, Prepend   -> Renamers.filerename `Prepend `date fninfos; exit 0
          | Rename,  DateTime, Insert    -> Renamers.filerename `Insert `date fninfos; exit 0
          | Rename,  DateTime, Append    -> (Printf.eprintf "Appending rename not supported for time switches\n%!"; exit 1)
          | Rename,  Md5,      Append    -> (Printf.eprintf "Appending rename not supported for md5\n%!"; exit 1)
          | Rename,  Md5,      Insert    -> Renamers.filerename `Insert  `md5 fninfos; exit 0
          | Rename,  Md5,      Prepend   -> Renamers.filerename `Prepend `md5 fninfos; exit 0
          | Rename,  Dirname,  Prepend   -> Renamers.prependdirname filenames; exit 0
          (* --------------------------------- *)
          | Move,    DateTime, _         -> Movers.movefiles_to_datedir filenames; exit 0
          (* --------------------------------- *)
          | Move,    Md5,      _         -> Movers.movefiles_to_md5dir filenames; exit 0
          | _,       Dirname,  _         -> no_valid_option_was_selected "-dn not available in this combination with the other switches"
          | _,       _,        Default    -> () (* is unneded *)
          | No_action, _        , _       -> () (* is excluded already *)
          (* --------------------------------- *)
  end;

  Printf.eprintf "No available functionality has been seleted.\n%!"; exit 1 (* fallback *)
