use strict;
use warnings;

use Data::Dumper;

$ |= 1;

sub main
{
  my %food=(
    "mice" => "cheese",
    "dogs" => "meat",
    "birds" => "seeds",
  );
  while(my ($key, $value) = each %food)
  {
    print "$key : $value\n"; 
  }

  foreach my $key(sort keys %food)
  {
    my $value = $food{$key};
    print "ver2 $key => $value\n";
  }


}

main();
