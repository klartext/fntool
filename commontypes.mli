type rename_mode = Default | Prepend | Insert | Append
type action = Rename | Move | No_action
type propselect = Md5 | DateTime | Dirname | Size
exception Cli_selection
