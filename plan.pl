# create a Bible reading plan, based on the dat files read in
# note: throughout I am using simple pipe-delimited data, even internally,
# rather than a more complex standard like JSON. Pipe-delimited is simple, fits the data,
# and is relatively easy to work with and so that's why that design decision was made.

use strict; 
use warnings;
use File::Slurp; 
use Throw;
use Data::Dumper;
use POSIX;

print "TODO: CHECK FOR SKIPPED PASSAGES/VERSES AS A BOOK IS READ - INDICATOR 'CHECK'\n";
print "TODO: IMPROVE PRINTING OF END OF PASSAGE WHEN VERSES INCLUDED IN BEGINNING OF PASSAGE\n";

# definitions
my $REFERENCED = "R";
my $FINISHED = "FIN";
my $CHECK = "CHECK";

# application level variables
my %book = ();
my @validCat = ("OT","W", "NT");
my $desiredDailyWords = 5000;
my %bibleData;
my %bookCat = ();
my $totalWords = 0;
my $previousKey;
my $currentKey;
my @line;
my @lineData;
# loop control
my $looping;
my $len;
my $idx;


# read bible book metadata in
@line = read_file( "book.dat" );


# read in the list of books and their categories
foreach( @line ) {

   chomp( $_ );
   @lineData = split(/\|/, $_ );

   # check for bad category
   my $cat = $lineData[2];

   if ( !grep( /^$cat$/, @validCat ) ) {
      throw "Bad category in book.dat: $lineData[0] => $cat";
   }

   $book{ $lineData[0] } = { "name" => $lineData[1], "category" => $lineData[2] };
}

# read the Bible data in (verses and their wordcount)
# this was calculated by the bookChapterVerseWords.pl app
# loop control
my $verseList = "";

@line = read_file( "bookChapterVerseWords.dat" );
$len = scalar @line;

$looping = 1;
$idx = 0;
do {
   if ( $idx >= $len ) {
      # past the last row
      $looping = 0;
      $currentKey = ""; # clear the current key
   }
   else {
      # read and parse the line
      my $l = $line[ $idx ]; 
      chomp( $l );
      @lineData = split(/\|/, $l );
      # get the current line key
      $currentKey = $lineData[0] . "|" . $lineData[1];
   }

   if ( $idx == 0 ) { # on the first row, initialize previous key
      $previousKey = $currentKey;
      $verseList = "";
   }
   $idx++;

   # if the key changed, store the previous data and reset
   if( $currentKey ne $previousKey ) {
      $bibleData{ $previousKey } = $verseList;
      $previousKey = $currentKey;
      $verseList = "";
   }

   if ( $looping ) { # if not past the end, grab current data
      # get current data
      $verseList .= $lineData[2] . "|" . $lineData[3] . "|";
      # add to cumulatives
      $totalWords += $lineData[3];
      my $category = $book{ $lineData[0] }{ "category" };
      if ( !defined $bookCat{ $category } ) {
         $bookCat{ $category } = 0;
      }
      $bookCat{ $category } += $lineData[3];
   }

} while ( $looping );

###print Dumper( %bookCat );
###print "======================\n";
###print Dumper( %bibleData );
###print "======================\n";
print "TOTAL WORDS: $totalWords\n";

my $planDays = ceil( $totalWords / $desiredDailyWords );
print "Plan Days: " . $planDays . "\n";

print "DAILY PACE:\n";
print "OT: " . ceil( $bookCat{ "OT" } / $planDays ) . "\n";
print "W: " . ceil( $bookCat{ "W" } / $planDays ) . "\n";
print "NT: " .  $bookCat{ "NT" } / $planDays  . "\n";
print "\n";

# now read the plan
@line = read_file( "plan.dat" );
my $currentOrd = "0";
my $day = 0;
my $dayWordCount = 0;
my $wordsReadSoFar = 0;
my $reading = "";
my %catCount = ();

$len = scalar @line;
$looping = 1;
$idx = 0;
do {
   if ( $idx >= $len ) {
      # past the last row
      $looping = 0;
      $currentKey = ""; # clear the current key
   }
   else {
      # read and parse the line
      my $l = $line[ $idx ]; 
      chomp( $l );
      @lineData = split(/\|/, $l );
      # get the current line key
      $currentKey = $lineData[0];
   }

   if ( $idx == 0 ) { # on the first row, initialize previous key
      $previousKey = $currentKey;
      $reading = "";
   }
   $idx++;

   # if the key changed, store the previous data and reset
   if( $currentKey ne $previousKey ) {
      $wordsReadSoFar += $dayWordCount;
      &printDay( ($day + 1), $dayWordCount, $reading, $wordsReadSoFar, $planDays, $totalWords, \%bookCat, \%catCount);
      $day++;
      $dayWordCount = 0;
      # setup for next key
      $previousKey = $currentKey;
      $reading = "";
   }

   if ( $looping ) { # if not past the end, grab current data
      # get current data
      if ( $reading gt "" ) {
         $reading .= "|";
      }

      $reading .= $lineData[1] . "|" . $lineData[2] . "|" . $lineData[3] . "|" . $lineData[4];      
      my $bibleKey = $lineData[1] . "|" . $lineData[2];

      # add to cumulatives
      my $startV = $lineData[3];
      my $endV = $lineData[4];
      # get the word count for this line
      my $wc = &wordCount($bibleKey, $startV, $endV);
      $dayWordCount += $wc;
      my $category = $book{ $lineData[1] }{ "category" };

      if ( !defined $catCount{ $category } ) {
         $catCount{ $category } = 0;
      }
      $catCount{ $category } += $wc;

      # check for a $FINISHED comment, meaning current book should be 
      # finished, and please check for any unread content
      if ( defined( $lineData[ 5 ] ) && $lineData[ 5 ] eq $FINISHED ) {
         # check all keys for the current book - ensure all reading finished
         my $b = $lineData[ 1 ];
         
         # this is a brute-force loop through the entire Bible array
         # all keys for the book that is finished should be marked as referenced
         foreach my $k ( keys %bibleData ) {
            if ( substr( $k, 0, 3 ) eq $b ) {
               if ( $bibleData{ $k } ne $REFERENCED ) {
                  throw "MISSING FROM PLAN: verses in $k\n";
               }
            }
         }
      }
   }

} while ( $looping );

sub wordCount {
   my ( $key, $startV, $endV ) = @_;

   my $verseList = $bibleData{$key};
   if ( !defined $verseList ) {
      throw "$key KEY NOT FOUND in bibleData array";
   }

   if ( $verseList eq $REFERENCED ) {
      throw "$key has already been referenced in the plan";
   }

   my @verse = split(/\|/, $verseList );

   my $wc = 0;
   if ( $startV eq "0" && $endV eq "0" ) {
      # get word count for the entire chapter
      # word counts are in every other element
      for ( my $i = 1; $i < scalar @verse; $i += 2 ) {
         ###if ( $verse[ $i] == -1 ) { print "NEGATIVE 1 FOUND\n"; }
         $wc += $verse[$i];
      }
      # since chapter referenced, remove the verse list
      $bibleData{$key} = $REFERENCED;
   }
   else {
      for ( my $i = 0; $i < scalar @verse; $i += 2 ) {
         if ( $verse[$i] >= $startV && $verse[$i] <= $endV ) {
            if ( $verse[ $i + 1 ] == -1 ) {
               throw "$key verse " . $verse[ $i ] . " has already been referenced in the plan";
            }
            $wc += $verse[$i + 1];
            $verse[$i + 1] = -1; # mark the verse as referenced
         }
      }
      # store the verse list with referenced verses removed
      # first - check to see if all the verses are -1 - if so, just 
      # store _REFERENCED_
      my $unreferencedVerses = 0;
      for ( my $j = 0; $j < scalar @verse; $j += 2 ) {
         if ( $verse[ $j + 1 ] > -1 ) {
            $unreferencedVerses++;
         }
      }
      if ( $unreferencedVerses == 0 ) {
         $bibleData{$key} = $REFERENCED; # all verses referenced
      }
      else {
         $bibleData{$key} = join( "|", @verse );
      }
      ###print $key . " - " . $bibleData{$key} . "\n\n";
   }

   return $wc;
}

sub printDay {
   my $day = $_[0];
   my $dayWc = $_[1];
   my $reading = $_[2];
   my $wordsReadSoFar = $_[3];
   my $planDays = $_[4];
   my $totalWords = $_[5];
   my %bookCat = %{$_[6]};
   my %catCount = %{$_[7]};

   my %passage = ();

   my @pDat = split(/\|/, $reading );

   my $element = 0;
   my $book = "";
   my $chapter = "";
   my $startingVerse = "";
   my $endingVerse = "";
   my $ord = 0; # to keep a basic order in the passages based on where they are in the plan

   foreach( @pDat ) {

      if ( $element == 0 ) {
         $book = $_;
         if ( !exists( $passage{$book}) ) {
            $ord++;
            $passage{ $book } = {"ord" => $ord, "minNum" => 1000000, "maxNum" => 0 };
         }
      }
      elsif ( $element == 1 ) {
         $chapter = $_;
      }
      elsif ( $element == 2 ) {
         $startingVerse = $_;
         
         my $chapVerse = "";
         my $chapVerseNum; 

         if ( $startingVerse gt "0") {
            $chapVerse = "$chapter:$startingVerse";
            $chapVerseNum = $chapter * 1000 + $startingVerse;
         }
         else {
            $chapVerse = "$chapter";
            $chapVerseNum = $chapter * 1000;
         }

         if ( $chapVerseNum < $passage{ $book }{"minNum"} ) {
            $passage{ $book }{"min"} = $chapVerse;
            $passage{ $book }{"minNum"} = $chapVerseNum;
         }
      }
      elsif ( $element == 3 ) {
         $endingVerse = $_;

         my $chapVerse = "";
         my $chapVerseNum;

         if ( $endingVerse gt "0") {
            $chapVerse = "$chapter:$endingVerse";
            $chapVerseNum = $chapter * 1000 + $endingVerse;
         }
         else {
            $chapVerse = "$chapter";
            $chapVerseNum = $chapter * 1000;
         }

         if ( $chapVerseNum > $passage{ $book }{"maxNum"} ) {
            $passage{ $book }{"max"} = $chapVerse;
            $passage{ $book }{"maxNum"} = $chapVerseNum;
         }

#         print "$book, $chapter, $startingVerse, $endingVerse\n";
         $element = -1;
      }

      $element++;
   }

   # now, categorize, spruce up, and print the day
   my @ot = ();
   my @wisdom = ();
   my @nt = ();

   foreach my $key ( keys %passage ) {
      my $ord = $passage{ $key }{"ord"};
      my $cat = $book{ $key }{"category"};
      my $name = $book{ $key }{"name"};
      my $minPassage = $passage{ $key }{"min"};
      my $maxPassage = $passage{ $key }{"max"};

      my $reading = $ord . "|";
      if ( $minPassage eq $maxPassage ) {
         if ( $name eq "Psalms" ) {
            $name = "Psalm";
         }

         $reading .= "$name $minPassage"
      }
      else {
         if ( index( $minPassage, ":" ) != -1 ) { #this reading has verse divisions
            my @min = split(/\:/, $minPassage );
            my @max = split(/\:/, $maxPassage );

            # see if they are within one chapter
            if ( $min[0] eq $max[0] ) {
               if ( $name eq "Psalms" ) {
                  $name = "Psalm";
               }
               $reading .= "$name $minPassage-" . $max[1]; # just the second verse
            }
            else {
               $reading .= "$name $minPassage-$maxPassage"; # show chapters on both
            }
         }
         else {
            $reading .= "$name $minPassage-$maxPassage"
         }
      }

      if ( $cat eq "OT" ) {
         push( @ot, $reading )
      }
      elsif ( $cat eq "W" ) {
         push( @wisdom, $reading )
      }
      elsif ( $cat eq "NT" ) {
         push( @nt, $reading )
      }
   }

   print $day;
   &printCategory( sort( @ot ) );
   &printCategory( sort( @wisdom ) );
   &printCategory( sort( @nt ) );
   my $totalPace = ceil( $totalWords / $planDays * $day );
   my $totalOffPace = $wordsReadSoFar - $totalPace;

   ## Note: assuming cats of OT, W, NT
   my $totalOTPace = ceil( $bookCat{"OT"} / $planDays * $day);
   my $totalOTOffPace = $catCount{"OT"} - $totalOTPace;
   my $totalWPace = ceil( $bookCat{"W"}  / $planDays * $day);
   my $totalWOffPace = $catCount{"W"} - $totalWPace;
   my $totalNTPace = ceil( $bookCat{"NT"}  / $planDays * $day);
   my $totalNTOffPace = $catCount{"NT"} - $totalNTPace;


##   print "|WORDCOUNT|$dayWc|WORDSREADSOFAR|$wordsReadSoFar|TOTALOFFPACE|$totalOffPace";
##   print "|OTCATCOUNT|" . $catCount{ "OT" } . "|TOTALOTOFFPACE|$totalOTOffPace";
##   print "|WCATCOUNT|" . $catCount{ "W" } . "|TOTALWOFFPACE|$totalWOffPace";
##   print "|NTCATCOUNT|" . $catCount{ "NT" } . "|TOTALNTOFFPACE|$totalNTOffPace";

   print "|WORDCOUNT|$dayWc|TOTALOFFPACE|$totalOffPace";
   print "|TOTALOTOFFPACE|$totalOTOffPace";
   print "|TOTALWOFFPACE|$totalWOffPace";
   print "|TOTALNTOFFPACE|$totalNTOffPace";

   print "\n";

   ###print Dumper( %catCount );
}

sub printCategory {
   my ( @r ) = @_;

   my $sepChar = "|";

   if ( scalar @r == 0 ) {
      print $sepChar; # print just one pipe and be done
   }
   else {
      foreach ( @r ) {
         my @passage = split(/\|/, $_ ); # do this to remove the order

         print $sepChar . $passage[1];
         $sepChar = ","; # after initial pipe, switch to commas
      }   
   }
}