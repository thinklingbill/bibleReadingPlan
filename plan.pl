# create a Bible reading plan, based on the dat files read in
# note: throughout I am using simple pipe-delimited data, even internally,
# rather than a more complex standard like JSON. Pipe-delimited is simple, fits the data,
# and is relatively easy to work with and so that's why that design decision was made.

use strict; use warnings;
use File::Slurp; 
use Throw;
use Data::Dumper;

# read bible book metadata in
my @line = read_file( "book.dat" );

my %book = ();
my @validCat = ("OT","W", "NT");

foreach( @line ) {

   chomp( $_ );
   my @bDat = split(/\|/, $_ );

   # check for bad category
   my $cat = $bDat[2];

   if ( !grep( /^$cat$/, @validCat ) ) {
      throw "Bad category in book.dat: $bDat[0] => $cat";
   }

   $book{ $bDat[0] } = { "name" => $bDat[1], "category" => $bDat[2] };
}

#print Dumper( %book );


# read the Bible data in
my %bibleData;

my $currentKey = "0";

@line = read_file( "bookChapterVerseWords.dat" );

my $verseList = "";

#my $currentBook = "0";

print "TODO: Gather total wordcount for OT, W, and NT categories\n";

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

   # if desired, print out the individual book abbreviations
   #my $book = $bDat[0];
   #if ( $currentBook ne $book ) {
   #   print "$book\n";
   #   $currentBook = $book;
   #}
}
# store final verse list
$bibleData{ $currentKey } = $verseList;

# now read the plan
@line = read_file( "plan.dat" );
my $currentOrd = "0";
my $day = 0;
my $wordCount = 0;
my $reading = "";

print "TODO: For each line read in, add its word count to a running count for that category so pace can be determined (show words off pace for each cat)\n";
print "TODO: MARK OFF REFERENCED INDIVIDUAL VERSES\n";

foreach( @line ) {

   my $r = $_;
   chomp $r;

   my @pDat = split(/\|/, $r );

#   print Dumper( @pDat);

   my $ord = $pDat[0];
   if ( $ord ne $currentOrd ) {
      if ( $currentOrd ne "0" ) {
         # not at the initial point, so print the day
#         print "DAY: $day";
         &printDay( $day, $wordCount, $reading);
         $reading = "";  #reset
      }
      $currentOrd = $ord;
      $day++;
      $wordCount = 0;
   }

   # add to day's reading
   if ( $reading gt "" ) {
      $reading .= "|";
   }

   $reading .= $pDat[1] . "|" . $pDat[2] . "|" . $pDat[3] . "|" . $pDat[4];

   # lookup the book and chapter
   my $key = $pDat[1] . "|" . $pDat[2];

   # get the start verse and end verse
   my $startV = $pDat[3];
   my $endV = $pDat[4];

   # get the word count for this line
   $wordCount += &wordCount($key, $startV, $endV);
}

# write out final day
#print "Final day: $day\n";
&printDay( $day, $wordCount, $reading );

print "TODO: NEED TO CHECK FOR ANY UNREFERENCED PASSAGES\n";

sub wordCount {
   my ( $key, $startV, $endV ) = @_;

   my $verseList = $bibleData{$key};
   if ( !defined $verseList ) {
      throw "$key key not found in bibleData array";
   }

   if ( $verseList eq "REFERENCED" ) {
      throw "$key key has already been referenced in the plan";
   }

   my @verse = split(/\|/, $verseList );

   my $wordCount = 0;
   if ( $startV eq "0" && $endV eq "0" ) {
      # get word count for the entire chapter
      # word counts are in every other element
      for ( my $i = 1; $i < scalar @verse; $i += 2 ) {
         $wordCount += $verse[$i];
      }
      # since chapter referenced, remove the verse list
      $bibleData{$key} = "REFERENCED";
   }
   else {
      for ( my $i = 0; $i < scalar @verse; $i += 2 ) {
         if ( $verse[$i] ge $startV && $verse[$i] le $endV ) {
            $wordCount += $verse[$i + 1];
         }
      }
      # note: will need to remove verses already referenced in the verse list
   }

   return $wordCount;
}

sub printDay {
   my ($day,$wordCount,$reading) = @_;

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
            $passage{ $book } = {"ord" => $ord, "min" => "Z", "max" => "0" };
         }
      }
      elsif ( $element == 1 ) {
         $chapter = $_;
      }
      elsif ( $element == 2 ) {
         $startingVerse = $_;
         
         my $chapVerse = "";

         if ( $startingVerse gt "0") {
            $chapVerse = "$chapter:$startingVerse"
         }
         else {
            $chapVerse = "$chapter"
         }
         if ( $chapVerse lt $passage{ $book }{"min"} ) {
            $passage{ $book }{"min"} = $chapVerse;
         }
      }
      elsif ( $element == 3 ) {
         $endingVerse = $_;

         my $chapVerse = "";

         if ( $endingVerse gt "0") {
            $chapVerse = "$chapter:$endingVerse"
         }
         else {
            $chapVerse = "$chapter"
         }
         if ( $chapVerse gt $passage{ $book }{"max"} ) {
            $passage{ $book }{"max"} = $chapVerse;
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
   print "|$wordCount";
   print "\n";
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