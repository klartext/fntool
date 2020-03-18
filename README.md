# fntool - a tool to rename and move files, depending on the files properties

## fntool name
fntool stands for filename tool.

## Intention
** fntool **
was written to rename and move files depending on the properties
of the files.
The reason to do that is, to achieve a certain kind of order of the files in
the filenames or put them into directories that reflect the certain kind of
order in their names.

## Use-cases
The order could be the creation-date of the file.
So if you have a bunch of downloaded files, and you want to order the files
according to the order of the download time (which means: creation time of
that file), then this can be done easily with this tool.

Another use case would be: collect all files of a certain date together into a
directory, named after the date of the files.

If it's planned to move a lot of files which are located in sub directories of
your current working directory directly into the current working directory, but
to keep the order that was given by the names of the sub directories, then
prepending the name of the subdirectories of these files to the name of these
files will solve the task.


# Building fntool

## Prerequisites
You need the standard installation of OCaml installed.
No extra packages are needed.

## Compilation
Just type the 'make' command at the shell prompt and the binary 'fntool' should be built



# Usage

## Options: Output of **fntool -h**

    fntool: unknown option '-h'.
    Use "datedir-filemove" following options:
      -ad      allow dir to be moved too.
      -md5     use md5-sum of file.
      -ty      year: prepend file-date inclduding year (st_mtime).
      -tmon    month: prepend file-date inclduding month (st_mtime).
      -td      day: prepend file-date inclduding day (st_mtime).
      -th      time: use hours of file-time (st_mtime) too.
      -tm      time: use minutes of file-time (st_mtime) too.
      -ts      time: use seconds of file-time (st_mtime) too.
      -tf      time: use float of st.st_mtime (and no other date-/time-stuff)
      -rn      renaming file
      -rnmode  rename-mode: p = prepend, i = insert before extension, a = append (default: prepend).
      -mv      move file into a directory
      -dn      use dirname
      -help    Display this list of options
      --help   Display this list of options


It's necessary to use either -rm or -mv switch and then add other switches,
which select the functionality.

## Examples

Move all pdf files into folders of the form yyyy-mm-dd,
where yyyy is the year, mm the months and dd the day of month of the creation date of
the pdf-file that is moved into this directory:

    $ fntool -mv -td *.pdf

Prepend the date of all files of current dir with date yyyy-mm-dd as well as time
in the format hh'h'mm'm'ss's:

    $ fntool -rn -ts *

