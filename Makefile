all: native-code
#all: byte-code
#all: debug-code


SOURCES :=  commontypes.ml cli.ml tools.ml fileinfo.ml fswrite.ml movers.ml renamers.ml main.ml

PACKS := unix

OCAMLFLAGS := -w +11+22+26+32+33+34+35+36+37+38+39-58 -safe-string

RESULT = fntool


include OCamlMakefile
