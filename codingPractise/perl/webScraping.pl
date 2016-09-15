use strict;
use warnings;

use LWP::Simple;


sub main
{
  #[0-9] any number
  #[A-Z] any uppercase letter(in the English alphabet)
  #[^0-9T\s] ^ Match anything EXCEPT the specified characters.
  #[\=\%] simply list alternatives. Backslash any character that might have a special meaning
  #[ABC] list of alternates
  my $content = "The 39 Steps- a GREAT book";


  #/([^0-9T\s]{5,})/
  if( $content =~ /([A-Z]{2,})/ )
  {
    print "Matched '$1'\n"; 
  }
  else
  {
    print "No match\n"; 
  } 


  $content = get("http://www.caveofprogramming.com");

  unless(defined($content))
  {
    die("Unreachable url\n"); 
  }

  # <a href="http://news.bbc.co.uk">BBC News</a>
  # []
  while($content =~ m|<\s*a\s+[^>]*href\s*=\s*['"]([^>"']+)['"][^>]*>([^<>]+)</|sig)
  {
    print "$2: $1\n"; 
  }

  # my @classes = $content =~ m|class="([^"']*?)"|ig;

  # if(@classes == 0)
  # {
  #   print "No matches\n";
  # }
  # else
  # {
  #   foreach my $class(@classes)
  #   {
  #     # print "$class\n";   
  #  }
  # } 

}


main();
