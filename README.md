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

**fntool** is a merge of a bunch of ad-hoc filerenamer tools.
So for this historical reason some of the functionality and command line
switches may seem inconsistent.

The implemented functionality and defaults follow some semantic decisions
of the old tools.

So these properties may change in the future (for example more functionality
and more consistent command line switches).


## Options: Output of **fntool -help**

    Use "fntool" with the following options:
      -ad      allow dir to be moved too.
      -md5     use md5-sum of file.
      -ty      time year:    use file's last modification time as YYYY.
      -tmon    time month:   use file's last modification time as YYYY-MM.
      -td      time day:     use file's last modification time as YYYY-MM-DD
      -th      time hours:   use file's last modification time as YYYY-MM-DD_hh'h'
      -tm      time minutes: use file's last modification time as YYYY-MM-DD_hh'h'mm'm'
      -ts      time seconds: use file's last modification time as YYYY-MM-DD_hh'h'mm'm'ss's'
      -tf      time float:   use file's last modification time since unix epoche as float value (%f)
      -rn      renaming file
      -rnmode  rename-mode: p = prepend, i = insert before extension, a = append (default: prepend).
      -mv      move file into a directory
      -dn      prepend current dirname to file / dir
      -help    Display this list of options
      --help   Display this list of options

## Functionality in Detail, with Default Values

Currently there are three mutual exclusive actions available: rename (-rn), move (-mv), prepend-dirname (-dn).

Based on certain use cases there are different subfunctionalities and defaults.


The switches -ty, -tmon, ty, ..., -tf are **time** switches.


### Rename (-rn)

The renaming options allows to rename files, and with the -ad swicth also to rename directories.

|  property  |  prepend  |  insert    |  append    |
|  ------  |  -------  |  ------    |  ------    |
|  time    |  default  |  ./.       |  ./.       |
|  md5     |  default  |  -rnmode i |  -rnmode a |


### Move (-mv)

Moving means a directory will be created, based on the properties
of the files. Properties are time or checksum.
The files (and with option -ad directories also) will be then moved into these directories.


### Prepend Dirnames (-dn)

The files



## Examples

Move all pdf files into folders of the form yyyy-mm-dd,
where yyyy is the year, mm the months and dd the day of month of the creation date of
the pdf-file that is moved into this directory:

    $ fntool -mv -td *.pdf

Prepend the date of all files of current dir with date yyyy-mm-dd as well as time
in the format hh'h'mm'm'ss's:

    $ fntool -rn -ts *

