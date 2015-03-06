#!/usr/bin/perl -w
scalar(@ARGV) == 1 or die "Usage: beat2TextGrid.pl inputfile";
$stem = shift;

$sur = "beats/$stem.beats";

open(FILE, $sur) || die("Could not open file!");
@lines = <FILE>;
close (FILE);

$L = scalar(@lines);
@words = split(/\s/, $lines[$L-1]);
$max_t = $words[1];

open(OUT, ">TextGrid/$stem.TextGrid")  or die "eek";
print OUT "File type = \"ooTextFile\"\nObject class = \"TextGrid\"\n\nxmin = 0\n";
print OUT "xmax = $max_t\n";
print OUT "tiers? <exists>\nsize = 1\nitem []:\n\titem [1]:\n\t\tclass = \"IntervalTier\"\n\t\tname = \"p-center\"\n\t\txmin = 0\n";
print OUT "\t\txmax = $max_t\n";
print OUT "\t\tintervals: size = $L\n";

for($i=1;$i<$L+1;$i++){ 
	print OUT "\t\tintervals [$i]:";
	@words = split(/\s/, $lines[$i-1]);
	print OUT "\n\t\t\txmin = $words[0]\n";
	print OUT "\t\t\txmax = $words[1]\n";
	print OUT "\t\t\ttext = \"$words[2]\"\n";
}

close(OUT);

print "Creating TextGrid file name in TextGrid/ $stem\n";