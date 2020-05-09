(*
  This source code is part of the program 'tfntool'

  Copyright: Oliver Bandel
  Copyleft:  GNU GPL v3 or higher/later version

  Use this software at your own risk.
*)

type rename_mode = Default | Prepend | Insert | Append
type action = Rename | Move | No_action
type propselect  = Md5 | DateTime | Dirname | Size

exception Cli_selection



