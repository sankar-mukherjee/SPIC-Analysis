#!/usr/bin/perl -w
scalar(@ARGV) == 1 or die "Usage: beat2TextGrid.pl inputfile";
$stem = shift;

$sur = "beats/$stem.beats";

open(FILE, $sur) || die("Could not open file!");
@lines = <FILE>;
close (FILE);

$L = scalar(@lines);
$rr = $lines[11]+1;

open(OUT, ">TextGrid/$stem.TextGrid")  or die "eek";
print OUT "File type = \"ooTextFile\"\nObject class = \"TextGrid\"\n\nxmin = 0\n";
print OUT "xmax = $lines[4]";
print OUT "tiers? <exists>\nsize = 1\nitem []:\n\titem [1]:\n\t\tclass = \"IntervalTier\"\n\t\tname = \"p-center\"\n\t\txmin = 0\n";
print OUT "\t\txmax = $lines[10]";
print OUT "\t\tintervals: size = $rr\n";
$j=1;
for($i=12;$i<$L-1;$i+=2){ 
	print OUT "\t\tintervals [$j]:";
	if($i==12){
		print OUT "\n\t\t\txmin = 0";
		print OUT "\n\t\t\txmax = $lines[$i]";
		print OUT "\t\t\ttext = $lines[$i+1]";
	}else{
		print OUT "\n\t\t\txmin = $lines[$i-2]";
		print OUT "\t\t\txmax = $lines[$i]";
		print OUT "\t\t\ttext = $lines[$i+1]";
	}
	$j++;
}
print OUT "\t\tintervals [$j]:";
print OUT "\n\t\t\txmin = $lines[$L-2]";
print OUT "\t\t\txmax = $lines[4]";
print OUT "\t\t\ttext = $lines[$L-1]";

close(OUT);


print "Creating TextGrid file name in TextGrid/ $stem\n";