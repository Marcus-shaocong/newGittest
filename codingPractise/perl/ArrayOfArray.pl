use strict;
use warnings;

use Data::Dumper;

$|=1;
sub main
{
  my $inputFile = 'test.csv';

  unless(open(INPUT,$inputFile))
  {
    die("cannot open test File"); 
  }
  
  my @lines;
  <INPUT>;
  while(my $line = <INPUT> )
  {
    print "'$line'\n";
    chomp $line;
    print "'$line'";
    if(defined $line)
    {
       my @value = split /\s*,\s*/, $line;
       push @lines, \@value;
    }


    #print Dumper(@lines);
  }
  close(INPUT);

  foreach my $item (@lines)
  {
    print "$item->[0]\n";
  }
}

main();
