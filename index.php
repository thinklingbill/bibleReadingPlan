<?php
# Produces a PDF of the Bible Reading Plan

require('fpdf182/fpdf.php');

define("VERSION", "4.0");
define("LEFT_MARGIN", 0.75);
define("RIGHT_MARGIN", 0.5);
define("TOP_MARGIN", 0.5);
define("BOTTOM_MARGIN", 1);
define("TITLE_HEIGHT", 1);
define("FOOTER_HEIGHT", 0.5);
define("COL_WIDTH", array(0.25, 0.4, 1.8, 1.8, 1.8, 0.8));
define("ROW_HEIGHT", 0.2);
define("FOOTNOTE_HEIGHT", 0.2);
define("FOOTNOTE_TEXT", "* Word counts based on the King James version");
define("ROWS_PER_PAGE", 40);

class PDF extends FPDF
{
    function Header()
    {
        $this->SetFont('Arial', 'B', 15);
        $this->Cell($this->getPageWidth() - (LEFT_MARGIN + RIGHT_MARGIN), TITLE_HEIGHT, 'Bible Reading Plan: "Sevens"', 0, 0, 'C');
        // Line break
        $this->Ln();

        $this->setFont('', 'B', 8);
        $this->Cell(COL_WIDTH[0], ROW_HEIGHT, "", 'R', 0, 'C', false);
        $this->Cell(COL_WIDTH[1], ROW_HEIGHT, "Day", 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[2], ROW_HEIGHT, "Reading 1", 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[3], ROW_HEIGHT, "Reading 2", 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[4], ROW_HEIGHT, "Reading 3", 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[5], ROW_HEIGHT, "Words *", 'LRT', 0, 'C', $fill);
        $this->Ln();
    }

    function ReadingPlanTable($kjvBook, $data)
    {
        $fill = false;
        $this->setFont('', '', 8);
        $this->SetFillColor(220, 220, 220);

        $prevDay = 0;
        $col = array(3);
        $colIx = 0;
        $lineCtr = 0;
        $rowCount = 0;

        // Gather number of words per verse/chapter/etc in the KJV
        $counts = array();
        $read = array();
        $grandTotalWords = 0;
        # gather the chapters, verses and number of words per verse in the bible
        foreach ($kjvBook as $b) {
            $wordsPerBook = 0;
            $jsonFile = "Bible-kjv/" . str_replace(" ", "", $b) . ".json";
            //print( "Processing $jsonFile\n");
            $j =  json_decode(file_get_contents($jsonFile));

            # read through the json, gathering chapters, verses per chapter, and word counts per chapter and verse
            $chapterCount = 0;
            foreach ($j->{"chapters"} as $c) {
                $chapterCount++;
                $chap = $c->{"chapter"};
                $verseCount = 0;
                $wordsPerChapter = 0;
                foreach ($c->{"verses"}  as $v) {
                    // remove unicode characters, because they are being counted as words
                    $text = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $v->{"text"});
                    $wordsPerVerse = str_word_count($text, 0);
                    $verse = $v->{"verse"};
                    $wordsPerChapter += $wordsPerVerse;
                    $wordsPerBook += $wordsPerVerse;
                    $grandTotalWords += $wordsPerVerse;
                    $verseCount++;
                    $counts[$b]["$chap.$verse"] = $wordsPerVerse;
                    $read[$b]["$chap.$verse"] = 0;
                }
            }
        }

        // gather daily words in the plan
        $dayWords = array();

        foreach ($data as $row) {
            $bookName = $row["book_name"];
            foreach ($counts[$bookName] as $key => $value) {
                $k = explode(".", $key);
                # full chapter
                if ($row["start_verse"] == 0) {
                    if ($k[0] >= $row["start_chapter"] and $k[0] <= $row["end_chapter"]) {
                        $read[$bookName][$key]++;
                        if (!isset($dayWords[$row["day_id"]])) {
                            $dayWords[$row["day_id"]] = $value;
                        } else {
                            $dayWords[$row["day_id"]] += $value;
                        }
                    }
                } else { # partial chapter. NOTE: assume no cross-chapter reading
                    if ($k[0] == $row["start_chapter"] and $k[1] >= $row["start_verse"] and $k[1] <= $row["end_verse"]) {
                        $read[$bookName][$key]++;
                        if (!isset($dayWords[$p->{"day_id"}])) {
                            $dayWords[$row["day_id"]] = $value;
                        } else {
                            $dayWords[$row["day_id"]] += $value;
                        }
                    }
                }
            }
        }

        // plan integrity check
        # find any verses read more than once or not at all
        $dupReads = 0;
        $problem = 0;
        foreach ($read as $k => $ar) {
            foreach ($ar as $j => $value) {
                if ($value == 0) {
                    print("$k, chapter.verse $j is never read\n");
                    $problem++;
                }
                if ($value > 1) {
                    print("$k, chapter.verse $j is read $value times\n");
                    $dupReads += $counts[$k][$j];
                    $problem++;
                }
            }
        }
        if ($dupReads > 0) {
            print("Passages duplicated: $dupReads\n");
            die;
        }

        if ($problem > 0) {
            print "\n******** $problem problem(s) found in the plan\n";
            die;
        }

        // print out the plan as a PDF
        foreach ($data as $row) {
            $rowCount++;

            $day = $row["day_id"];
            if ($day != $prevDay) { // write out the build up row (if $prevDay > 0 )
                if ($prevDay > 0) {
                    if ($lineCtr >= ROWS_PER_PAGE) {
                        $this->addPage();
                        $lineCtr = 0;
                    }

                    switch ($lineCtr) {
                        case (ROWS_PER_PAGE - 1): // on last row
                            $border = "LRB";
                            break;
                        case 0: // on first row
                            $border = "LRT";
                            break;
                        default:
                            $border = "LR";
                            break;
                    }
                    $this->Cell(COL_WIDTH[0], ROW_HEIGHT, $this->Rect($this->GetX() + .075, $this->GetY() + .075, 0.1, 0.1), 'R', 0, 'C', false);
                    $this->Cell(COL_WIDTH[1], ROW_HEIGHT, $prevDay, $border, 0, 'L', $fill);
                    $this->Cell(COL_WIDTH[2], ROW_HEIGHT, $col[0], $border, 0, 'L', $fill);
                    $this->Cell(COL_WIDTH[3], ROW_HEIGHT, $col[1], $border, 0, 'L', $fill);
                    $this->Cell(COL_WIDTH[4], ROW_HEIGHT, $col[2], $border, 0, 'L', $fill);
                    $this->Cell(COL_WIDTH[5], ROW_HEIGHT, number_format($dayWords[$prevDay]), $border, 0, 'R', $fill);
                    $this->Ln();
                    $lineCtr++;

                    if ($lineCtr == ROWS_PER_PAGE) {
                        $this->Cell(COL_WIDTH[0], FOOTNOTE_HEIGHT, "", 0, 0, 'L');
                        $this->setFont('', 'I', 0);
                        $this->Cell(0, FOOTNOTE_HEIGHT, FOOTNOTE_TEXT, 0, 0, 'L');
                        $this->setFont('', '', 0);
                    }
                }
                $fill = !$fill;
                $prevDay = $day;
                $col[0] = "";
                $col[1] = "";
                $col[2] = "";
                $colIx = 0;
            }

            if ($row["start_verse"] > 0) {
                $chapVerse = $row["start_chapter"] . ":" . $row["start_verse"];
                if ($row["start_chapter"] == $row["end_chapter"]) {
                    $chapVerse .= "-" . $row["end_verse"];
                } else {
                    $chapVerse .= "-" . $row["endChapter"] . ":" . $row["end_verse"];
                }
            } else {
                $chapVerse = $row["start_chapter"];
                if ($row["end_chapter"] > $row["start_chapter"]) {
                    $chapVerse .= "-" . $row["end_chapter"];
                }
            }
            $entry = $row["book_name"] . " " . $chapVerse;

            // if col 0 not yet filled, but this is a wisdom book in the OT, advance to col 1
            if ($row["book_type_name"] == "Wisdom" && $row["testament_id"] == 1) {
                if ($colIx != 1) {
                    $colIx = 1;
                }
            }

            // if col 0 or 1 not yet filled, but this is an NT book, advance to col 2
            if ($row["testament_id"] == 2) {
                if ($colIx != 2) {
                    $colIx = 2;
                }
            }

            if ($col[$colIx] > "") {
                if ($colIx < 2) {
                    $colIx++;
                }
            }
            if ($col[$colIx] > "") {
                $col[$colIx] .= ", ";
            }
            $col[$colIx] .= $entry;

            // check to see if we've run out of data. If we have, write out the last row
            // I know this is uber-repetitive.
            if ($rowCount >= sizeOf($data)) {
                $this->Cell(COL_WIDTH[0], ROW_HEIGHT, $this->Rect($this->GetX() + .075, $this->GetY() + .075, 0.1, 0.1), 'R', 0, 'C', false);
                $this->Cell(COL_WIDTH[1], ROW_HEIGHT, $prevDay, 'LRB', 0, 'L', $fill);
                $this->Cell(COL_WIDTH[2], ROW_HEIGHT, $col[0], 'LRB', 0, 'L', $fill);
                $this->Cell(COL_WIDTH[3], ROW_HEIGHT, $col[1], 'LRB', 0, 'L', $fill);
                $this->Cell(COL_WIDTH[4], ROW_HEIGHT, $col[2], 'LRB', 0, 'L', $fill);
                $this->Cell(COL_WIDTH[5], ROW_HEIGHT, number_format($dayWords[$prevDay]), 'LRB', 0, 'R', $fill);
                $this->Ln();

                $this->Cell(COL_WIDTH[0], FOOTNOTE_HEIGHT, "", 0, 0, 'L');
                $this->setFont('', 'I', 0);
                $this->Cell(0, FOOTNOTE_HEIGHT, FOOTNOTE_TEXT, 0, 0, 'L');
                $this->setFont('', '', 0);
            }
        }
    }

    function Footer()
    {
        // Go to 1 in from bottom
        $this->SetY(-BOTTOM_MARGIN);
        // Select Arial italic 8
        $this->SetFont('Arial', 'I', 8);
        // Print centered page number
        $this->Cell(0, FOOTER_HEIGHT, 'Version ' . VERSION . ' - Page ' . $this->PageNo(), 0, 0, 'C');
    }
}

$mysqli = new mysqli("127.0.0.1", "root", "helloW0rld", "bible_reading_plan");

// Check connection
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: " . $mysqli->connect_error;
    exit();
}

// collect the reading plan data
$sql = "
select bp.day_id
      ,bb.book_name
      ,bp.start_chapter
      ,bp.start_verse
      ,bp.end_chapter
      ,bp.end_verse
      ,bbt.book_type_name
      ,bb.testament_id
from bible_plan bp
join bible_book bb on bb.book_id = bp.book_id
join bible_book_type bbt on bbt.book_type_id = bb.book_type_id
order by 
     bp.day_id
	,bb.testament_id
    ,bbt.ord
    ,bb.book_id
    ;
";

// retrieve Bible plan
$data = array();
if ($result = $mysqli->query($sql)) {
    // build the PDF
    while ($row = $result->fetch_assoc()) {
        array_push($data, $row);
    }

    // Free result set
    $result->free_result();
}

$mysqli->close();

// retrieve KJV bible text for statistics
// get list of books (Note: assumed we've already validated that
// the book names match the names in our plan)
$kjvBook =  json_decode(file_get_contents("Bible-kjv/Books.json"));

// build PDF

$pdf = new PDF('P', 'in', 'Letter');
$pdf->SetDrawColor(0, 0, 0);
$pdf->SetFont('Arial', '', 10);
$pdf->SetMargins(LEFT_MARGIN, TOP_MARGIN, RIGHT_MARGIN);
$pdf->AddPage();

$pdf->ReadingPlanTable($kjvBook, $data);
$pdf->Output();
?>?>