<?php
# counts the number of words for each day in the plan
# Useful for balancing the daily reading
# also validates that each chapter and verse is read once
# note: kjv jsons in the Bible-kjv directory come from https://github.com/aruljohn/Bible-kjv.git

echo "Read in list of kjv books\n";
$kjvBook =  json_decode( file_get_contents(  "Bible-kjv/Books.json" ) );
#print_r( $kjvBook );

echo "Check for book name/book id mismatches\n";
# (this is a brute-force method of getting
# a unique list of book names from the plan)
$planBook = array();
$plan =  json_decode( file_get_contents(  "bibleReadingPlan.json" ) );

foreach( $plan as $p ) {
    $planBook[ $p->{ "book_id" } ] = $p->{"book_name"};
}

# the book ids in the plan bookName are 1 greater than the ones from the KJV json
# loop through each plan book, see if it matches the kjv book
$errors = 0;
foreach ( $planBook as $i => $n ) {
    $kjvKey = $i - 1;
    if ( !array_key_exists( $kjvKey, $kjvBook )) {
        echo "Key does not exist: $i - $n\n";
        $errors++;
    }
    else {
        if ( $kjvBook[ $kjvKey ] <> $n ) {
            echo "Key mismatch: $i - $n. Either key is mismatched or name is different\n";
            $errors++;
        }
    }
}

print "$errors Errors detected\n";

# if no errors, continue
$counts = array();
$read = array();
if ( !$errors ) {
    # gather the chapters, verses and number of words per verse in the bible
    foreach ( $kjvBook as $b ) {
        $jsonFile = "Bible-kjv/" . str_replace( " ", "", $b ) . ".json";
        print( "Processing $jsonFile\n");
        $j =  json_decode( file_get_contents(  $jsonFile ) );

        # read through the json, gathering chapters, verses per chapter, and word counts per chapter and verse
        $chapterCount = 0;
        foreach( $j->{"chapters"} as $c ) {
            $chapterCount++;  
            $chap = $c->{"chapter"};          
#            print( "Chapter: " . $c->{"chapter"} . "\n" );
            $verseCount = 0;
            $wordsPerChapter = 0;
            foreach( $c->{"verses"}  as $v ) {
                $wordsPerVerse = str_word_count( $v->{"text"}, 0 );
#                print( "Verse: " . $v->{"verse"} . ", words: $wordsPerVerse\n" );
                #print( "Text:" . $v->{"text"} . "| Word count: $wordsPerVerse\n" );
                $verse = $v->{"verse"};
                $wordsPerChapter += $wordsPerVerse;
                $verseCount++;
                $counts[ $b ][ "$chap.$verse"] = $wordsPerVerse;
                $read[ $b ][ "$chap.$verse" ] = 0;
            }
#            print( "Words for chapter " . $c->{"chapter"} . ": $wordsPerChapter\n");
#            print_r( $counts ); die;
        }
    }
}

echo "Read in the current bible reading plan Json exported from mysql workbench\n";

$dayWords = array();
$count = 0;
foreach ( $plan as $p ) {
    $count++;
    # this is exceptionally brute force...
    $bookName = $p->{"book_name"};
    foreach( $counts[ $bookName ] as $key => $value) {
        $k = explode( ".", $key );
        # full chapter
        if ( $p->{"start_verse"} == 0 ) {
            if ( $k[0] >= $p->{"start_chapter"} and $k[0] <= $p->{"end_chapter"}) {
#               print( "marking $bookName, $key to 1\n" );
                $read[$bookName][$key]++;
                $dayWords[ $p->{"day_id"} ] += $value;
            }
        }
        else { # partial chapter. NOTE: assume no cros-chapter reading
            if ( $k[0] == $p->{"start_chapter"} and $k[1] >= $p->{"start_verse"} and $k[1] <= $p->{"end_verse"}) {
                $read[$bookName][$key]++;
                $dayWords[ $p->{"day_id"} ] += $value;                
             }
        }
    }

#    if ( $count > 5 ) die;
}

# find any verses read more than once or not at all
$dupReads = 0;
$problem = 0;
foreach ( $read as $k => $ar ) {
    foreach( $ar as $j => $value ) {
        if ( $value == 0 ) { 
            print( "$k, chapter.verse $j is never read\n");
            $problem++;
        }
        if ( $value > 1 ) { 
            print( "$k, chapter.verse $j is read $value times\n");
            $dupReads += $counts[ $k ][ $j ];
            $problem++;
        }
    }
}
if ( $dupReads > 0 ) {
    print( "Words duplicated: $dupReads\n");
}

#if ( $problem ) die;

$total = 0;
foreach( $dayWords as $key => $value ) {
    print( "$key = $value\n");
    $total += $value;
}

print ( "TOTAL WORDS: $total\n");

 
#    if ( !array_key_exists( $dayId, $versesPerDay ) ) {

?>
