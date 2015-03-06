#!/usr/bin/perl -w
scalar(@ARGV) == 1 or scalar(@ARGV) == 2 or die "Usage: getBeats.pl inputfilestem <threshold>";
$stem = shift;

# Parameters to fiddle with
if (scalar(@ARGV) == 0) {
  $threshold = 0.2;
} else {
  $threshold = shift;
  print "Threshold is $threshold\n";
}

open(IN, "$stem.intensity") or die "badly";
open(OUT, ">$stem.beats")  or die "eek";

# File type = "ooTextFile short"
$_ = <IN>; print OUT $_;

# replace "Intensity" with "TextGrid"
$_ = <IN>; print OUT "\"TextGrid\"\n\n";

# skip a line
$_ = <IN>;

chomp($xmin = <IN>);
chomp($xmax = <IN>);
chomp($nx = <IN>);  $nx = 0; #(just suprress a arning here)
chomp($dx = <IN>);
chomp($x1 = <IN>);

# Read in intensity contour into @e (envelope)
@e = ();
while($_ = <IN>) { chomp; last unless $_ eq "1";}
push @e, $_;

while($_ = <IN>) {
  chomp($_);
  push @e, $_;
}


# (1) Find max and min
$max = 0; $min = 1000000;
foreach $ival (@e) {
  if($ival > $max) {
    $max = $ival;
  }
  if($ival < $min) {
    $min = $ival;
  }
}

# (2) look for beats
@beats = ();

print "Thresh: $threshold\n";

$threshold = $threshold * ($max - $min);

print "thresh: $threshold, max: $max, min: $min\n";

$slopeStartIx = 0;
$finished = 0;

TOPLOOP: while(!$finished) {
  
  # look for a rise that exceeds threshold
  while($e[$slopeStartIx + 1] <= $e[$slopeStartIx]) {
    if($slopeStartIx >= ($#e - 1)) {
      $finished = 1;
      next TOPLOOP;
    }
    $slopeStartIx = $slopeStartIx + 1;
  }

  # find the start of the rise
  while(($slopeStartIx >= 1) & ($e[$slopeStartIx - 1] < $e[$slopeStartIx])) {
    $slopeStartIx = $slopeStartIx - 1;
  }

  # find the end of the rise
  $slopeEndIx = $slopeStartIx + 1;

  if ($slopeEndIx >= $#e) {
    $finished = 1;
    next TOPLOOP;
  }
  print "ss = $slopeStartIx.. ";
  
  while($e[$slopeEndIx] <= $e[$slopeEndIx + 1]) {
    $slopeEndIx = $slopeEndIx + 1;
    if($slopeEndIx >= $#e) {
      $finished = 1;
      next TOPLOOP;
    }
  }

  $peak = $slopeEndIx;

  print "peak: $peak..";


  #    Find that point that lies half way between 0.1 and 0.9 of the rise

  $diff = $e[$slopeEndIx] - $e[$slopeStartIx];

  if($diff > $threshold) {

    $loLim = $e[$slopeStartIx] + 0.1 * $diff;
    $hiLim = $e[$slopeEndIx] - 0.1 * $diff;
      
    while($e[$slopeStartIx] < $loLim) { $slopeStartIx = $slopeStartIx + 1;}

    while($e[$slopeEndIx] > $hiLim) { $slopeEndIx = $slopeEndIx - 1;}

    $beat = ($slopeEndIx + $slopeStartIx)/2;
    print "beat at index $beat\n";

    push @beats, $beat;  # later we will reconstruct the time from the index.....

  } else {
    print "Negligible diff found ($diff, $threshold)\n";
  }

  $slopeStartIx = $peak;

  if($slopeStartIx >= $#e) { $finished = 1;}
}

$nBeats = scalar(@beats);

# Now write out a short text file in praat format

print OUT "$xmin\n";
print OUT "$xmax\n";
print OUT "<exists>\n";
print OUT "1\n";   # number of tiers
print OUT "\"TextTier\"\n";
print OUT "\"beats\"\n";
print OUT  "$xmin\n";
print OUT "$xmax\n";
print OUT "$nBeats\n";

foreach $b (@beats) {
  $beattime = $x1 + $dx*$b;
  print OUT "$beattime\n";
  print OUT "\"b\"\n";
}



