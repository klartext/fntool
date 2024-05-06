(*
  This source code is part of the program 'fntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

type oldname = string
type newname = string
type dirname = string


module type Provider =
sig
    val move_or_print: oldname -> newname -> dirname -> unit
    val rename_or_print: oldname -> newname -> unit
end


module Action = functor (IN: Provider) ->
struct
    (* helper to create directories *)
    (* ---------------------------- *)
    let create_dir_if_not_exists dirname =
      if Sys.file_exists dirname then () else Unix.mkdir dirname 0o700

    (* file-mover function *)
    (* ------------------- *)
    let move_files_to_newdir namemapping =
      List.iter ( fun (fname, dir_name) ->
                                      create_dir_if_not_exists dir_name;
                                      let newname = Filename.concat dir_name fname in
                                      IN.move_or_print fname newname dir_name
                ) namemapping


    (* file renamer function *)
    (* --------------------- *)
    let do_rename (fileinfo : Fileinfo.fileinfo) newname =
      if Sys.file_exists newname then (Printf.eprintf "target-filename exists already: could not rename %s to %s\n" fileinfo.fni.filename newname )
      else
        begin
          Printf.printf "renaming %s" fileinfo.fni.filename;
          Printf.printf " to %s\n" newname;
          flush stdout;
          IN.rename_or_print fileinfo.fni.filename newname
        end
end



module Renamer : Provider =
struct
    let move_or_print oldfn newfn dirname =
        Unix.rename oldfn newfn;
        Printf.printf "file moved to dir:  %12s  <---  %s\n%!" dirname oldfn

    let rename_or_print oldfn newfn =
        Sys.rename oldfn newfn
end


module GitPrinter : Provider =
struct
    let move_or_print oldname newname dirname = Printf.printf "git mv %s %s\n" oldname dirname
    let rename_or_print oldname newname = Printf.printf "git mv %s %s\n" oldname newname
end


module A = Action(Renamer)
module B = Action(GitPrinter)


let move_files_to_newdir = A.move_files_to_newdir
let do_rename = A.do_rename

let gitcmd_move_files_to_newdir = B.move_files_to_newdir
let gitcmd_do_rename = B.do_rename
