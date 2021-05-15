<?php
# counts the number of words for each day in the plan
# Useful for balancing the daily reading
# also validates that each chapter and verse is read once
# note: kjv jsons in the Bible-kjv directory come from https://github.com/aruljohn/Bible-kjv.git

# Note: I've validated the total words in this json version of the Bible to various 
# internet resources. It is very close, but can be a couple of words of per book (although many match exactly)
# I'm not sure the difference but possibly slightly different versions of the KJV. Close enough for my purposes
# though.

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

if ( $errors ) die;

# if no errors, continue
$counts = array();
$read = array();
$grandTotalWords = 0;
    # gather the chapters, verses and number of words per verse in the bible
    foreach ( $kjvBook as $b ) {
        $wordsPerBook = 0;
        $jsonFile = "Bible-kjv/" . str_replace( " ", "", $b ) . ".json";
        //print( "Processing $jsonFile\n");
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
                // remove unicode characters, because they are being counted as words
                $text = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $v->{"text"});
                $wordsPerVerse = str_word_count( $text, 0 );
#                print( "Verse: " . $v->{"verse"} . ", words: $wordsPerVerse\n" );
                #print( "Text:" . $v->{"text"} . "| Word count: $wordsPerVerse\n" );
                $verse = $v->{"verse"};
                $wordsPerChapter += $wordsPerVerse;
                $wordsPerBook += $wordsPerVerse;
                $grandTotalWords += $wordsPerVerse;
                $verseCount++;
                $counts[ $b ][ "$chap.$verse"] = $wordsPerVerse;
                $read[ $b ][ "$chap.$verse" ] = 0;
            }
        }
        print( "TOTAL NUMBER OF WORDS IN $b: $wordsPerBook\n");
    }

print ("TOTAL NUMBER OF WORDS IN THE KJV BIBLE JSON: $grandTotalWords\n");

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
                $read[$bookName][$key]++;
                if ( !isset( $dayWords[ $p->{"day_id"} ] ) ) {
                   $dayWords[ $p->{"day_id"} ] = $value;
                } else {
                   $dayWords[ $p->{"day_id"} ] += $value;
                }
            }
        }
        else { # partial chapter. NOTE: assume no cros-chapter reading
            if ( $k[0] == $p->{"start_chapter"} and $k[1] >= $p->{"start_verse"} and $k[1] <= $p->{"end_verse"}) {
                $read[$bookName][$key]++;
                if ( !isset( $dayWords[ $p->{"day_id"} ] ) ) {
                   $dayWords[ $p->{"day_id"} ] = $value;
                } else {
                   $dayWords[ $p->{"day_id"} ] += $value;
                }
             }
        }
    }
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
    print( "Passages duplicated: $dupReads\n");
}

if ( $problem > 0 ) {
    print "\n******** $problem problem(s) found in the plan\n";
}
else {
    print "\nNo problems found in the plan!\n";
}

if (!function_exists('stats_standard_deviation')) {
    // note: from https://www.php.net/manual/en/function.stats-standard-deviation.php
    /**
     * This user-land implementation follows the implementation quite strictly;
     * it does not attempt to improve the code or algorithm in any way. It will
     * raise a warning if you have fewer than 2 values in your array, just like
     * the extension does (although as an E_USER_WARNING, not E_WARNING).
     *
     * @param array $a
     * @param bool $sample [optional] Defaults to false
     * @return float|bool The standard deviation or false on error.
     */
    function stats_standard_deviation(array $a, $sample = false) {
        $n = count($a);
        if ($n === 0) {
            trigger_error("The array has zero elements", E_USER_WARNING);
            return false;
        }
        if ($sample && $n === 1) {
            trigger_error("The array has only 1 element", E_USER_WARNING);
            return false;
        }
        $mean = array_sum($a) / $n;
        $carry = 0.0;
        foreach ($a as $val) {
            $d = ((double) $val) - $mean;
            $carry += $d * $d;
        };
        if ($sample) {
           --$n;
        }
        return sqrt($carry / $n);
    }
}

$total = 0;
foreach( $dayWords as $key => $value ) {
    $total += $value;
}

$stdDev = round( stats_standard_deviation( $dayWords ), 0 );
$avg = round( $total / count( $dayWords), 0 );

print "****************\n";
print ( "Day|Words|StdDeviations\n");
foreach( $dayWords as $key => $value ) {
    $stdDeviations = round(( $value - $avg )/$stdDev, 2 );
    print( "$key|$value|$stdDeviations\n");
}

print "\n***OUTLIERS****************\n";

print ( "Day|Words|StdDeviations\n");
foreach( $dayWords as $key => $value ) {
    $stdDeviations = round(( $value - $avg )/$stdDev, 2 );
    if ( $value > 6000 or $value < 3000 ) {
       print( "$key|$value|$stdDeviations\n");
    }
}
    
print ( "TOTAL WORDS: $total\n");
print ( "AVERAGE PER DAY: $avg\n");
print ( "STD DEVIATION: $stdDev\n");    


?>
