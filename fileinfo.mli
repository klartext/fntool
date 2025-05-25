type fninfo = {
  filename : string;
  dirname : string;
  basename : string;
  chopped_filename : string;
  chopped_basename : string;
  extension : string;
}
type dt = { datetime : float; }
type fileinfo = {
  fni : fninfo;
  digest : string option;
  datetime : dt option;
  sizestr : string option;
}
val size_of_file : string -> int
val size_of_file_as_string : string -> string
val digest_of_file : string -> string
val make_fileinfo : string -> fileinfo
val create_prepend_dirname : string -> string
val create_mappinglist :
  [< `date | `dirname | `md5 | `size > `date `md5 `size ] ->
  string list -> (fileinfo * string) list
