(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

(*
open Fileinfo
*)

let date_of_file  ?(month=false)
                  ?(day=false)
                  ?(hours=false)
                  ?(minutes=false)
                  ?(seconds=false)
                  ?(usefloat=false)
                  fname =
  let open Unix in
  let s = stat fname in
  let tm = s.st_mtime |>localtime in

  let year = tm.tm_year in
  let mon  = tm.tm_mon  in
  let mday = tm.tm_mday in
  let hr   = tm.tm_hour in
  let min  = tm.tm_min  in
  let sec  = tm.tm_sec  in

  if usefloat
  then
    Printf.sprintf "%f" s.st_mtime
  else
  begin (* no float *)
    match month, day, hours, minutes, seconds with
      | false, false, false, false, false -> Printf.sprintf "%4d" (1900 + year)
      | true,  false, false, false, false -> Printf.sprintf "%4d-%02d" (1900 + year) (1 + mon)
      | _,     true,  false, false, false -> Printf.sprintf "%4d-%02d-%02d" (1900 + year) (1 + mon) mday
      | _, _,         true,  false, false -> Printf.sprintf "%4d-%02d-%02d_%02dh" (1900 + year) (1 + mon) mday hr
      | _, _, _,      true,  false -> Printf.sprintf "%4d-%02d-%02d_%02dh%02dm" (1900 + year) (1 + mon) mday hr min
      | _, _, _,     _,     true  -> Printf.sprintf "%4d-%02d-%02d_%02dh%02dm%02ds" (1900 + year) (1 + mon) mday hr min sec

  end


(* --------------- *)
let datestring fname =
  let open Cli in
  date_of_file
    ~month:opt.month
    ~day:opt.day
    ~hours:opt.hour
    ~minutes:opt.min
    ~seconds:opt.sec
    fname
    ~usefloat:opt.usefloat


(* ----------------------------------- *)
(* ----------------------------------- *)
let is_regfile fname =
  let module U = Unix in
  let st = U.stat fname in
  match st.U.st_kind with
    | U.S_REG -> true
    | _       -> false


(* --------------- *)
let is_not_directory file = Sys.is_directory file |> not

let directdir path =
  String.split_on_char Filename.dir_sep.[0] path |> List.rev |> List.hd

let longestpath cwd fndn =
  if String.length cwd >= String.length fndn then cwd else fndn

let files_of_curdir () =
  Sys.readdir "." |> Array.to_list


