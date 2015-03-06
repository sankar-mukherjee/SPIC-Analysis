#!/usr/bin/perl -w
##   beat extraction
$threshold = 0.05;            # only consider onsets which exceed this, relative to signal maximum

scalar(@ARGV) == 1 or die "Usage: FindBeats.pl inputfile";
$stem = shift;

	#$sur = "$stem.wav";
	#$sur2 = "temp.au";
	#system("./script/sox $sur -r 16000 $sur2");
	
open(OUT, ">file.inf")  or die "eek";
print OUT "$stem.wav";
close(OUT);

system("./praatcon.exe wav2intensity.praat");
system("perl script/getBeatsOneShot.pl beats/$stem $threshold");

system("perl script/beat2TextGrid.pl $stem");

unlink("file.inf");
print "finished";