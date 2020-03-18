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


  let use_time = if opt.year || opt.month || opt.day || opt.hour || opt.min || opt.sec || opt.usefloat then true else false in
  let use_md5  = if opt.md5 then true else false in

  let selected_prop =
    match use_time, use_md5, opt.dn with
      | false, false, false -> no_valid_option_was_selected "select a property to use: time, md5 or dirname" (* better: show help-messages *)
      (* ------------------------------------------------- *)
      | false, true,  true  -> no_valid_option_was_selected "only use one option of: time, md5 or dirname"
      | true,  false, true  -> no_valid_option_was_selected "only use one option of: time, md5 or dirname"
      | true,  true,  false -> no_valid_option_was_selected "only use one option of: time, md5 or dirname"
      | true,  true,  true  -> no_valid_option_was_selected "only use one option of: time, md5 or dirname"
      (* ------------------------------------------------- *)
      | false, false, true  -> Dirname
      | false, true,  false -> Md5
      | true,  false, false -> DateTime
  in


  (* set rename-mode default *)
  (* ----------------------- *)
  begin
    match opt.rnmode, use_time, use_md5 with
      | _,       false, false -> no_valid_option_was_selected "select: md5 or time"
      | _,        true, true  -> no_valid_option_was_selected "not both options allowed togehter: md5 or time"
      | Default, false, true  -> opt.rnmode <- Insert
      | Default, true,  false -> opt.rnmode <- Prepend
      | _, _, _ -> ()
  end;

  (* set action and check on contradiction between move and rename *)
  (* ------------------------------------------------------------- *)
  let action   = ref No_action in
  begin
    match opt.move, opt.rename with
      | false, false -> no_valid_option_was_selected "please select either -mv or -rn"
      | true,  true  -> no_valid_option_was_selected "don't select both options: -mv and -rn"
      | false, true  -> action := Rename
      | true,  false -> action := Move
  end;


  let filenames = if opt.allow_dir then opt.file_list else List.filter Tools.is_not_directory opt.file_list  in
  let fninfos = List.map Fileinfo.getfilenameinfo opt.file_list in (* filenames statt opt.file_list -> vorfilterung dir/file *)
  (*
  let filenames = filenames @ Tools.files_of_curdir() in
  *)

  begin
    match !action, opt.rnmode, selected_prop with
          (* --------------------------------- *)
          | Rename,  Prepend,  Md5       -> Renamers.filerename `Prepend `md5 fninfos; exit 0
          | Rename,  Insert,   Md5       -> Renamers.filerename `Insert  `md5 fninfos; exit 0
          | Rename,  Append,   Md5       -> (Printf.eprintf "Appending rename not supported for md5\n%!"; exit 1)
          (* --------------------------------- *)
          | Move,    Prepend,  Md5       -> no_valid_option_was_selected "Move with md5 not implemented"
          | Move,    Insert,   Md5       -> no_valid_option_was_selected "Move with md5 not implemented"
          | Move,    Append,   Md5       -> no_valid_option_was_selected "Move with md5 not implemented"
          (* --------------------------------- *)
          | Rename,  Prepend,  DateTime  -> Renamers.filerename `Prepend `date fninfos; exit 0
          | Rename,  Insert,   DateTime  -> ()
          | Rename,  Append,   DateTime  -> ()
          (* --------------------------------- *)
          | Move,    _,        DateTime  -> Movers.movefilestodatedir filenames; exit 0
          (* --------------------------------- *)
          | Rename,  Prepend,  Dirname   -> Renamers.prependdirname filenames; exit 0
          | _,       _,        Dirname   -> no_valid_option_was_selected "No certain available functionality has been seleted"
          | _,       Default,  _         -> () (* is unneded *)
          | No_action, _ ,     _         -> () (* is excluded already *)
          (* --------------------------------- *)
  end;

  Printf.eprintf "No available functionality has been seleted.\n%!"; exit 1 (* fallback *)
