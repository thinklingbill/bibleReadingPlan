<?php
# counts the number of words for each day in the plan
# Useful for balancing the daily reading
# also validates that each chapter and verse is read once
# note: kjv jsons in the Bible-kjv directory come from https://github.com/aruljohn/Bible-kjv.git

echo "Read in the current bible reading plan Json exported from mysql workbench\n";
$plan =  json_decode( file_get_contents(  "bibleReadingPlan.json" ) );
#print_r( $plan );

echo "Read in list of kjv books\n";
$kjvBook =  json_decode( file_get_contents(  "Bible-kjv/Books.json" ) );
#print_r( $kjvBook );

echo "Check for book name/book id mismatches\n";
# (this is a brute-force method of getting
# a unique list of book names from the plan)
$planBook = array();

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
if ( !$errors ) {
    # gather the chapters, verses and number of words per verse in the bible
    foreach ( $kjvBook as $b ) {
        $b = "1 John";
        $jsonFile = "Bible-kjv/" . str_replace( " ", "", $b ) . ".json";
        print( "Processing $jsonFile\n");
        $j =  json_decode( file_get_contents(  $jsonFile ) );

        # read through the json, gathering chapters, verses per chapter, and word counts per chapter and verse
        $chapterCount = 0;
        foreach( $j->{"chapters"} as $c ) {
            $chapterCount++;            
            print( "Chapter: " . $c->{"chapter"} . "\n" );
            $verseCount = 0;
            $wordsPerChapter = 0;
            foreach( $c->{"verses"}  as $v ) {
                $wordsPerVerse = str_word_count( $v->{"text"}, 0 );
                print( "Verse: " . $v->{"verse"} . ", words: $wordsPerVerse\n" );
                #print( "Text:" . $v->{"text"} . "| Word count: $wordsPerVerse\n" );
                $wordsPerChapter += $wordsPerVerse;
                $verseCount++;
            }
            print( "Words for chapter " . $c->{"chapter"} . ": $wordsPerChapter\n");
        }
        die;
    }


}


#print_r ( $planBook );
 
#    if ( !array_key_exists( $dayId, $versesPerDay ) ) {

?>
