use strict;
use warnings;
use Data::Dumper;
use Getopt::Std;
use XML::Simple;
use DBI;
#use DBD::mysql;

=pod
  this is XML parser version 1.0
  use with care.

  perl CommandLineArgument.pl -d /home/c4dev/codingPractise/perl -e
=cut

sub main
{

  #all the command line arguments is stored in ARGV
  print Dumper(@ARGV);
  #print $ARGV[0];
  
  my %opts;
  getopts('d:e', \%opts);

  #print Dumper(%opts);

  if(!checkusage(\%opts))
  {
    usage(); 
  }
  
  my $dbh = DBI->connect("dbi:mysql:bands","root","password");

  unless(defined($dbh))
  {
    die "Cannot connect to database\n"; 
  }

  print "Connected to database\n";

  my $input_dir = $opts{"d"};
  my @files = get_files($input_dir);
  my @data = process_files(\@files, $input_dir);
  add_to_database($dbh, \@data);

  if($opts{"e"})
  {
    export_from_database($dbh); 
  }

  $dbh->disconnect();

  print "complete \n";
}

sub export_from_database
{
    my $dbh = shift;

    print "exporting ...\n";

    my $output_file = "output.txt";

    open OUTPUT, '>'.$output_file or "Cannot create output file $output_file.\n";

    my $sql = 'select b.id as band_id, b.name as band_name, a.id as album_id, ' .
    'a.name as album_name, a.position as position ' .
    'from Bands b join Albums a on a.band_id=b.id';

    my $sth = $dbh->prepare($sql);

    unless(defined($sth))
    {
      die ("unable to prepare export query.\n"); 
    }

    unless($sth->execute())
    {
      die ("unable to exeute export query.\n"); 
    } 

    while(my $row = $sth->fetchrow_hashref())
    {
      my $band_id = $row->{"band_id"};
      my $band_name = $row->{"band_name"};
      my $album_id = $row->{"album_id"};
      my $album_name = $row->{"album_name"};
      my $position = $row->{"position"};

      print OUTPUT "$band_id, $band_name , $album_id, $album_name, $position\n";
    }

    print "Export completed to $output_file \n";

    close OUTPUT;
}


sub add_to_database
{
  my ($dbh, $data) = @_;

   my $sth = $dbh->prepare('insert into Bands(name) values(?)');
   my $sth_album  = $dbh->prepare('insert into Albums(name, position, band_id) values(?,?,?)');

   unless($sth)
   {
      die "Error preparing SQL\n"; 
   }

   $dbh->do('delete from Bands') or die "Can't clean Bands talbe.\n";
   $dbh->do('delete from Albums') or die "Can't clean Albums table.\n";

  foreach my $item(@{$data})
  {
    my $band_name = $item->{"name"};
    print "Inserting $band_name into database ...\n";
    unless($sth->execute($band_name))
    {
      die "Error execute SQL\n"; 
    }
    my $band_id = $sth->{'mysql_insertid'};


    foreach my $album (@{$item->{"albums"}})
    {
      my $album_name = $album->{"name"};
      my $album_position = $album->{"position"};

      print "$album_name, $album_position\n";
      unless($sth_album->execute($album_name, $album_position, $band_id))
      {
        die "Unlable to execute albums insert.\n"; 
      }
    }
  }

  $sth->finish();
  $sth_album->finish();
}

sub get_files
{
  my $input_dir = shift;
  unless(opendir(INPUTDIR,$input_dir))
  {
    die("Unable to open directory '$input_dir'\n");
  }

  my @files = readdir(INPUTDIR);
  closedir(INPUTDIR);
  @files = grep(/\.xml$/i, @files);

  return @files;
}

sub process_files
{
  my($files, $input_dir) = @_;

  my @data;
  print "Input dir : $input_dir\n";
  print Dumper($files);
  foreach my $file(@{$files})
  {
    my @band_data = process_file($file, $input_dir);
    push @data, @band_data
  }
  return @data;
}

sub process_file
{
  my($file, $input_dir) = @_;
  print "Process $file on $input_dir\n";

  my $filepath = "$input_dir/$file";
  open(INPUTFILE, $filepath) or die("cannnot open $filepath\n");
=pod
  $/ = "</entry>";   # the gobal line separator
  my $count = 0;
  while(my $chunk = <INPUTFILE> )
  {
    print "\n\n$count: $chunk"; 

    #if we don't put () around $band, $band would be the return value of match, that means the value would be
    # 1 or 0, but if we put () around $band, that means $band is an array of the first element. then it would
    # contain the matched group part
    my ($band) = $chunk =~ m'<band>(.*?)</band>';

    unless(defined($band))
    {
      next; 
    }
    print "BAND: $band\n";

    my @albums = $chunk =~ m'<album>(.*?)</album>'sg;
    print "found " . scalar(@albums) . " for $band ...\n";
    print Dumper(@albums);
    $count++;
  }
  close(INPUFILE);
=cut

  #after undef this file separator, when reading file, 
  #it will return the whole file, by default it should be '\n'
  undef $/; 
  my $content = <INPUTFILE>;
  close(INPUTFILE);
  print $content;

  my $parser = new XML::Simple;
  my $dom = $parser->XMLin($content, ForceArray=>1);
  #print Dumper($dom);

  my @output;
   foreach my $band(@{$dom->{"entry"}})
   {
     my $band_name = $band->{"band"}->[0];
     #print Dumper($band->{"band"}->[0]); 
     my $albums = $band->{"album"};
     my @albumsArray;
     foreach my $album(@$albums)
     {
       my $album_name = $album->{"name"}->[0];
       my $chartposition = $album->{"chartposition"}->[0];
       push @albumsArray,{ 
        "name" => $album_name,
        "position" => $chartposition,
      };
     }
     push @output,{ 
        "name" => $band_name,
        "albums" => \@albumsArray,
      };
   }

   # print Dumper(\@output);
  return @output;
}

sub checkusage
{
  my $opts = shift;

  my $d = $opts->{"d"};
  my $r = $opts->{"r"};

  unless(defined($d))
  {
    return 0;
  } 

  return 1;
}

sub usage
{
  my $help = <<USAGE;
  usage: perl CommandLineArgument.pl -d <directory name> -a 
    -d <directory> specify XML file name to parse
    -e export data from database

USAGE

  die $help;
}

main();

