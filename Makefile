# Makefile for iCrate mounts

SCAD_FILES = icrate_mount.scad bar_mount.scad
OUTPUTS = $(SCAD_FILES:.scad=.stl)
PNG_OUTPUTS = $(SCAD_FILES:.scad=.png)

all: $(OUTPUTS)

images: $(PNG_OUTPUTS)

%.stl: %.scad
	openscad -o $@ $<

%.png: %.scad
	openscad -o $@ --imgsize=1024,1024 --projection=perspective --camera=0,0,0,60,0,25,500 $<

clean:
	rm -f $(OUTPUTS) $(PNG_OUTPUTS)

.PHONY: all clean images