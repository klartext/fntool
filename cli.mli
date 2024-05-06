type opt_t = {
  mutable allow_dir : bool;
  mutable file_list : string list;
  mutable year : bool;
  mutable month : bool;
  mutable day : bool;
  mutable hour : bool;
  mutable min : bool;
  mutable sec : bool;
  mutable usefloat : bool;
  mutable size : bool;
  mutable md5 : bool;
  mutable rename : bool;
  mutable rnmode : Commontypes.rename_mode;
  mutable move : bool;
  mutable dn : bool;
  mutable cwd : bool;
  mutable gitcmd : bool;
}
val opt : opt_t
val parse : unit -> unit
