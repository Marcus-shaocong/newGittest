use strict;
use warnings;

$|=1;
sub main
{
  my @file = ("./test.txt",
    "test2.txt",
  );

  my $outputFile = "test3.txt";
  foreach my $file(@file)
  {
    if( -f $file )
    {
      open(INPUT, $file) or die("Input file $file not found\n");
      open(OUTPUT, '>>' . $outputFile) or die("Cannot create $outputFile not found\n");
      while(my $line = <INPUT> )
      {
        if( $line =~ /\begg\b/)
        {
          $line =~ s/egg/chicken/ig;
           print OUTPUT "$line"; 
        }
      }
      close(INPUT);
      close(OUTPUT);
    }
    else
    {
      print "File not Found: $file\n";  
    }
  }
}

main();
