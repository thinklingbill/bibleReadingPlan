# This can be run once, with the results piped into a file
# for use in later steps
use strict;
use warnings;
use File::Slurp;

my @line = read_file( "kjvdat.txt" );

my $totalWords = 0;
my $verseCount = 0;
my $chapterCount = 0;
my $currentChapter = "0";
my $currentBook = "~";

foreach( @line ) {
   $verseCount++;

   # count the words in each line
   my @words = split(/\s+/, $_ );
   my @address = split(/\|/,$words[0] );
   if ( $address[0] ne $currentBook ) {
      $currentBook = $address[0];
      $currentChapter = "0"
   }
   if ( $address[1] ne $currentChapter ) {
      $currentChapter = $address[1];
      $chapterCount++;
   }

   print $words[0];
   print ( scalar( @words) - 1 );
   print "\n";
   $totalWords += scalar( @words) - 1;
}

#print "Total words: $totalWords\n";
#print "Total verses: $verseCount\n";
#print "Total chapters: $chapterCount\n";
