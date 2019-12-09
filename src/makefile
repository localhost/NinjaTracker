all: ninjatr2.prg ../example.prg ../ins2nt2.exe

ninjatr2.prg: ninjatr2.s ninjatr2.s nt2command.s nt2data.s nt2disk.s nt2display.s nt2helptext.s nt2key.s nt2math.s \
nt2packer.s nt2pattern.s nt2playback.s nt2player.s nt2raster.s nt2screen.s nt2songdata.s nt2table.s nt2track.s nt2var.s
	dasm ninjatr2.s -oninjatr2.prg -v3 -p3
	pucrunch ninjatr2.prg ninjatr2.prg -x2112
	prg2d64 ../ninjatr2.d64 NINJATRACKER2 ninjatr2.prg

../example.prg: example.s ../nt2play.s gamemusic.bin
	dasm example.s -o../example.prg -v3 -p3
	pucrunch ../example.prg ../example.prg -x2048

../ins2nt2.exe: ins2nt2.c endian.c gcommon.h
	gcc ins2nt2.c endian.c -o../ins2nt2.exe
	strip ../ins2nt2.exe
