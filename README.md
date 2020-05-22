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
Imagine you needed to download daily provided data over some weeks
and you used a cronjob and wget for it.
There will be numbers appended to the files by wget, but the order
listed by the shell is different than the order of the download-times.
The same problem occurs, when loading the files via globbing into your
data analysis machinery.
So, you could fiddle around with regular expressions and sorting to get the
files loaded in the correct order. Or you could just rename the files, so that
the download-date (creation date) is prepended to each of the files.
Then the timely order of the downloads is reflected in the filenames and make
it much easier to use your files.

Another use case would be: collect all files of a certain date together into a
directory, named after the date of the files.

If it's planned to move a lot of files which are located in sub directories of
your current working directory directly into the current working directory, but
to keep the order that was given by the names of the sub directories, then
prepending the name of the subdirectories of these files to the name of these
files will solve the task.


# Building fntool

## Prerequisites
You need the standard installation of OCaml installed (release 4.04 or newer).
No extra packages are needed.

## Compilation
Just type the 'make' command at the shell prompt and the binary 'fntool' should be built



# Usage

**fntool** is a merge of a bunch of ad-hoc filerenamer tools.
The implemented functionality and defaults follow some semantic decisions
of the old tools. Hopefully inconsistencies have been eradicated.


## Options: Output of **fntool -help**

    Use "fntool" with the following options:
      -ad      allow dir to be moved too.
      -md5     use md5-sum of file.
      -dn      prepend current dirname to file / dir
      -ty      time year:    use file's last modification time as YYYY.
      -tmon    time month:   use file's last modification time as YYYY-MM.
      -td      time day:     use file's last modification time as YYYY-MM-DD
      -th      time hours:   use file's last modification time as YYYY-MM-DD_hh'h'
      -tm      time minutes: use file's last modification time as YYYY-MM-DD_hh'h'mm'm'
      -ts      time seconds: use file's last modification time as YYYY-MM-DD_hh'h'mm'm'ss's'
      -tf      time float:   use file's last modification time since unix epoche as float value (%f)
      -s       size: use filesize
      -rn      renaming file
      -rnmode  rename-mode: p = prepend, i = insert before extension (default: prepend).
      -mv      move file into a directory
      -help    Display this list of options
      --help   Display this list of options


## Functionality in Detail, with Default Values

There are two mutual exclusive actions available: rename (-rn), move (-mv).

Based on certain use cases there are different subfunctionalities and defaults.

The switches -rn, -mv **action** switches.

The **property** switches at the moment have **time**, **checksum** and **dirname** as property.

The switches -ty, -tmon, ty, ..., -tf are time switches.

The switch -md5 is for the md5sum of a file.

The switch -s is the filesize switch.

The switch -dn is the dirname switch.

The switch -rnmode only has influence on the renaming action and allows to
select between prepending and inserting before the filename extension.


### Rename (-rn)

The renaming options allows to rename files, and with the -ad swicth also to rename directories.


| property | default   |
|----------|-----------|
| time     |  prepend  |
| md5      |  insert before extension   |
| dirname  |  prepend  |
| size     |  prepend  |


### Move (-mv)

Moving means a directory will be created, based on the properties
of the files. Properties are time or checksum.
The files (and with option -ad directories also) will be then moved into these directories.

The -rnmode switch is without influence here.


## Examples

Move all pdf files into folders of the form yyyy-mm-dd,
where yyyy is the year, mm the months and dd the day of month of the creation date of
the pdf-file that is moved into this directory:

    $ fntool -mv -td *.pdf

Prepend the date of all files of current dir with date yyyy-mm-dd as well as time
in the format hh'h'mm'm'ss's:

    $ fntool -rn -ts *

