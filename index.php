<?php
# Produces a PDF of the Bible Reading Plan

require('fpdf182/fpdf.php');

define( "LEFT_MARGIN", 0.75 );
define( "RIGHT_MARGIN", 0.5 );
define( "TOP_MARGIN", 0.5 );
define( "BOTTOM_MARGIN", 1 );
define( "TITLE_HEIGHT", 1 );
define( "FOOTER_HEIGHT", 0.5 );
define( "COL_WIDTH", array( 0.25, 0.5, 2.1, 2.1, 2.1 ) );
define( "ROW_HEIGHT", 0.2 );
define( "ROWS_PER_PAGE", 40 );

class PDF extends FPDF
{
    function Header() {
        $this->SetFont('Arial','B',15);
        $this->Cell($this->getPageWidth()-(LEFT_MARGIN + RIGHT_MARGIN),TITLE_HEIGHT,'Bible Reading Plan: "Sevens"',0,0,'C');
        // Line break
        $this->Ln();

      
        $this->setFont( '','B', 8 );
        $this->Cell(COL_WIDTH[0],ROW_HEIGHT,"",'R',0,'C',false);
        $this->Cell(COL_WIDTH[1],ROW_HEIGHT,"Day",'LRT',0,'L',$fill);
        $this->Cell(COL_WIDTH[2],ROW_HEIGHT,"Reading 1",'LRT',0,'L',$fill);
        $this->Cell(COL_WIDTH[3],ROW_HEIGHT,"Reading 2",'LRT',0,'L',$fill);
        $this->Cell(COL_WIDTH[4],ROW_HEIGHT,"Reading 3",'LRT',0,'L',$fill);
        $this->Ln();         
    }

    function ReadingPlanTable($data)
    {
        $fill = false;
        $this->setFont( '','', 8 );
        $this->SetFillColor(220,220,400);

        $prevDay = 0;
        $col = array(3);
        $colIx = 0;
        $lineCtr = 0;
        $rowCount = 0;

        foreach($data as $row) {
            $rowCount++;
            $day = $row[ "day"];
            if ( $day != $prevDay ) { // write out the build up row (if $prevDay > 0 )
                if ( $prevDay > 0 ) {
                    if ( $lineCtr >= ROWS_PER_PAGE ) {
                        $this->addPage();
                        $lineCtr = 0;
                    }

                    switch ( $lineCtr ) {
                        case (ROWS_PER_PAGE - 1 ) : // on last row
                            $border = "LRB";
                            break;
                        case 0 : // on first row
                            $border = "LRT";
                            break;
                        default :
                            $border = "LR";
                            break;
                    }
                    $this->Cell(COL_WIDTH[0],ROW_HEIGHT,$this->Rect($this->GetX()+.075, $this->GetY()+.075, 0.1, 0.1 ),'R',0,'C',false);
                    $this->Cell(COL_WIDTH[1],ROW_HEIGHT,$prevDay,$border,0,'L',$fill);
                    $this->Cell(COL_WIDTH[2],ROW_HEIGHT,$col[0],$border,0,'L',$fill);
                    $this->Cell(COL_WIDTH[3],ROW_HEIGHT,$col[1],$border,0,'L',$fill);
                    $this->Cell(COL_WIDTH[4],ROW_HEIGHT,$col[2],$border,0,'L',$fill);
                    $this->Ln();     
                    $lineCtr++;   
                }
                $fill = !$fill;
                $prevDay = $day;
                $col[0] = "";
                $col[1] = "";
                $col[2] = "";
                $colIx = 0;
            }

            if ( $row[ "start_verse"] > 0 ) {
                $chapVerse = $row["start_chapter"] . ":" . $row[ "start_verse"];
                if ( $row[ "start_chapter"] == $row[ "end_chapter"]) {
                    $chapVerse .= "-" . $row["end_verse"];
                }
                else {
                    $chapVerse .= "-" . $row["endChapter"] . ":" . $row["end_verse"];
                }
            }
            else {
                $chapVerse = $row["start_chapter"];
                if ( $row[ "end_chapter"] > $row[ "start_chapter"]) {
                    $chapVerse .= "-" . $row["end_chapter"];
                } 
            }
            $entry = $row[ "book_name"] . " " . $chapVerse;

            // if col 0 not yet filled, but this is a wisdom book in the OT, advance to col 1
            if ( $row["book_type_name"] == "Wisdom" && $row[ "testament_id"] == 1 ) {
                if ( $colIx != 1) {
                    $colIx = 1;
                }
            }

            // if col 0 or 1 not yet filled, but this is an NT book, advance to col 2
            if ( $row[ "testament_id"] == 2 ) {
                if ( $colIx != 2) {
                    $colIx = 2;
                }
            }

            if ( $col[ $colIx ] > "" ) {
                if ( $colIx < 2 ) {
                    $colIx++;
                }
            }
            if ( $col[ $colIx ] > "" ) {
                $col[ $colIx ] .= ", ";
            }
            $col[ $colIx ] .= $entry;

            // check to see if we've run out of data. If we have, write out the last row
            if ( $rowCount >= sizeOf( $data ) ) {
                $this->Cell(COL_WIDTH[0],ROW_HEIGHT,$this->Rect($this->GetX()+.075, $this->GetY()+.075, 0.1, 0.1 ),'R',0,'C',false);
                $this->Cell(COL_WIDTH[1],ROW_HEIGHT,$prevDay,'LRB',0,'L',$fill);
                $this->Cell(COL_WIDTH[2],ROW_HEIGHT,$col[0],'LRB',0,'L',$fill);
                $this->Cell(COL_WIDTH[3],ROW_HEIGHT,$col[1],'LRB',0,'L',$fill);
                $this->Cell(COL_WIDTH[4],ROW_HEIGHT,$col[2],'LRB',0,'L',$fill);
                $this->Ln();     
            }             
        }

    }
    function Footer() {
        // Go to 1 in from bottom
        $this->SetY(-BOTTOM_MARGIN);
        // Select Arial italic 8
        $this->SetFont('Arial','I',8);
        // Print centered page number
        $this->Cell(0,FOOTER_HEIGHT,'Version 3.0 - Page '.$this->PageNo(),0,0,'C');
    }    
}



#$mysqli = new mysqli("127.0.0.1","root","Agios#322&","bible_reading_plan");
$mysqli = new mysqli("127.0.0.1","root","helloW0rld","bible_reading_plan");

// Check connection
if ($mysqli -> connect_errno) {
  echo "Failed to connect to MySQL: " . $mysqli -> connect_error;
  exit();
}

// collect the reading plan data
$sql = "
select bp.day_id as day
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
if ($result = $mysqli -> query( $sql )) {
    // build the PDF
    while( $row = $result->fetch_assoc() ) {
        array_push( $data, $row );
    }    

    // Free result set
    $result -> free_result();
}
  
$mysqli -> close();

// build PDF

$pdf = new PDF( 'P', 'in', 'Letter');
$pdf->SetDrawColor( 0, 0, 0 );
$pdf->SetFont('Arial','',10);
$pdf->SetMargins( LEFT_MARGIN, TOP_MARGIN, RIGHT_MARGIN );
$pdf->AddPage();

$pdf->ReadingPlanTable( $data );

// $pdf->BasicTable($header,$data);
// $pdf->AddPage();
// $pdf->ImprovedTable($header,$data);
// $pdf->AddPage();
// $pdf->FancyTable($header,$data);
$pdf->Output();
?>?>
