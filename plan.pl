use strict; use warnings;
use File::Slurp; 
use Data::Dumper;
# read the Bible data inmy @line = read_file( "bookChapterVerseWords.dat" );

my %bibleData;

my $currentKey = "0";

my @line = read_file( "bookChapterVerseWords.dat" );

my $verseList = "";

my $count = 0;

foreach( @line ) {

   chomp( $_ );
   my @bDat = split(/\|/, $_ );

   my $key = $bDat[0] . "|" . $bDat[1];

   if ( $key ne $currentKey ) {
      if ( $currentKey ne "0" ) {
        # store verses
        $bibleData{ $currentKey } = $verseList;
        $verseList = "";
      }
      $currentKey = $key;
   }
   $verseList .= $bDat[2] . "|" . $bDat[3] . "|";
   $count++;

#   if ( $count > 200 ) {
#       last;
#   }
}
# store final verse list
$bibleData{ $currentKey } = $verseList;

print Dumper( %bibleData );

print $bibleData{"Rev|22"};