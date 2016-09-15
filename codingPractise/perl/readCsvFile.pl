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

  <INPUT>;
  while(my $line = <INPUT> )
  {
    #print "'$line'\n";
    chomp $line;
    my @value = split /\s*,\s*/, $line;

    print Dumper(@value);
  }
  close(INPUT);
}

main();
