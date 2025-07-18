type fileinfo = {
  filename : string;
  dirname : string;
  basename : string;
  chopped_filename : string;
  chopped_basename : string;
  extension : string;
}
val size_of_file : string -> int
val size_of_file_as_string : string -> string
val digest_of_file : string -> string
val create_prepend_dirname : string -> string
val create_mappinglist :
  [< `date | `dirname | `md5 | `size > `date `md5 `size ] ->
  string list -> (fileinfo * string) list

val show_mappinglist : (fileinfo * string) list -> unit
