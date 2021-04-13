<?php

$f = fopen( "LEB.xml", "r" );

$matches = array();

$bookAr = array();
$bookIx = 0;
$bookChap = array();
$bookChapVerse = array();
$bookChapRead = array();

while( $line = fgets( $f ) ) {
   preg_match_all( "/<verse-number id=\"([a-zA-Z0-9: ]*)\"/", $line, $matches );

   foreach( $matches[1] as $m ) {
#      print ("$m\n");

      if ( preg_match( "/([0-9]?\s?[A-Za-z]+)\s*([0-9]+):([0-9]+)/", $m, $matches2 ) ) {
         $book = $matches2[1];
         $chapter = $matches2[2];
         $verse = $matches2[3];
      }
      else if ( preg_match( "/([0-9]?\s?[A-Za-z]+)\s*([0-9]+)/", $m, $matches2 ) ) {
         $book = $matches2[1];
         $chapter = "1";
         $verse = $matches2[2];
      }
      else {
         print "MISMATCH: $m\n ";
         die;
      }
      
      print( $book . "|" . $chapter . "|" . $verse . "\n" );

      $bookChap[ $book ] = $chapter;
      $bookChapVerse[ $book ][ $chapter ] = $verse;
      $bookChapRead[ $book ][ $chapter ] = 0;

      // add to the book array if it isn't already there
      if ( !in_array( $book, $bookAr ) ) {
         $bookAr[ $bookIx++ ] = $book;
      } 
   }
}

print_r( $bookChap );
print_r( $bookChapVerse );

fclose( $f );

$bibleXref =  json_decode( file_get_contents(  "bibleBook.json" ) );

foreach( $bibleXref as $bx ) {
   print_r ( $bx );
} 

print_r( $bookAr );
print ( $bookAr[ 50 ] . " - " . $bibleXref[50]->{"book_name"} . "\n");
print ( $bookChap[ $bookAr[ 50 ] ] . " - " . $bibleXref[50]->{"chapters"} . "\n");

$i = 0;
foreach ( $bookAr as $b ) {
   if ( $bookChap[ $b ] <> $bibleXref[ $i ]->{"chapters"} ) {
      print "PROBLEM ON " . $bibleXref[ $i ]->{"book_name"} . ": LEB says " .  $bookChap[$b] . ", I have " . $bibleXref[ $i ]->{"chapters"} . "\n";
   }
   $i++;
}

# mark chapters read and accumulate verses per day
$bibleReadingPlan =  json_decode( file_get_contents(  "bibleReadingPlan.json" ) );

$versesPerDay = array();

foreach( $bibleReadingPlan as $brp ) {
   $dayId = $brp->{ "day_id" };

   if ( !array_key_exists( $dayId, $versesPerDay ) ) {
	   if ( $dayId == 8 ) {
		   print ( "INITIALIZING DAY 8\n" );
	   }
      $versesPerDay[ $dayId ] = 0; # initialized
   }

   # mark the chapters as read
   $bookIx = $brp->{ "book_id" } - 1;
 
   $s = $brp->{ "start_chapter" }; 
   $e = $brp->{ "end_chapter" }; 
   for ( $i=$s; $i<=$e; $i++ ) {
      $bookChapRead[ $bookAr[ $bookIx ] ][ $i ] += 1;

      if ( $brp->{ "start_verse" } > 0 ) {
         $versesPerDay[ $dayId ] += $brp->{"end_verse" } - $brp->{ "start_verse" } + 1;
      }
      else { 
         $versesPerDay[ $dayId ] += $bookChapVerse[ $bookAr[ $bookIx ] ][ $i ];
if ( $dayId == "8" ) {
   print "*** HERE ***  " . $bookAr[ $bookIx ] . " - " . " chapter $i " . $bookChapVerse[ $bookAr[ $bookIx ] ][ $i ] . "\n";
   print(" VERSES PER DAY: " . $versesPerDay[ $dayId ] . "\n" );
}
      }
   }

} 

# check for chapters never read
foreach ( $bookAr as $b ) {
   foreach ( $bookChapRead[ $b ] as $chapter => $timesRead ) {
      if ( $timesRead < 1 ) {
          print ( "******** $b chapter $chapter is never read ********\n" );
      }

      if ( $timesRead > 1 ) {
         print( "******** $b chapter $chapter is read $timesRead times ********\n" );
      }	 
   }
}

print_r ( $versesPerDay );

print_r ( $bookChapVerse[ "Mk" ] );



?>
