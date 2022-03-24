<?php
# Produces a PDF of the Bible Reading Plan

require('fpdf182/fpdf.php');

define("VERSION", "5.0");
define( "TITLE", "Read The Five Thousand");
define( "OT_TITLE", "Old Testament History/Prophecy");
define( "W_TITLE", "Old Testament Wisdom/Poetry");
define( "NT_TITLE", "New Testament");
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
        $this->Cell($this->getPageWidth() - (LEFT_MARGIN + RIGHT_MARGIN), TITLE_HEIGHT, TITLE, 0, 0, 'C');
        // Line break
        $this->Ln();

        $this->setFont('', 'B', 8);
        $this->Cell(COL_WIDTH[0], ROW_HEIGHT, "", 'R', 0, 'C', false);
        $this->Cell(COL_WIDTH[1], ROW_HEIGHT, "Day", 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[2], ROW_HEIGHT, OT_TITLE, 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[3], ROW_HEIGHT, W_TITLE, 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[4], ROW_HEIGHT, NT_TITLE, 'LRT', 0, 'C', $fill);
        $this->Cell(COL_WIDTH[5], ROW_HEIGHT, "Words *", 'LRT', 0, 'C', $fill);
        $this->Ln();
    }

    function printPlan( $plan ) {
        $fill = false;
        $this->setFont('', '', 8);
        $this->SetFillColor(220, 220, 220);
        $lineCtr = 0;

        foreach ($plan as $row) {
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
            $this->Cell(COL_WIDTH[1], ROW_HEIGHT, $row->{"day"}, $border, 0, 'L', $fill);
            $this->Cell(COL_WIDTH[2], ROW_HEIGHT, $row->{"old_testament_history_prophecy"}, $border, 0, 'L', $fill);
            $this->Cell(COL_WIDTH[3], ROW_HEIGHT, $row->{"old_testament_wisdom_poetry"}, $border, 0, 'L', $fill);
            $this->Cell(COL_WIDTH[4], ROW_HEIGHT, $row->{"new_testament"}, $border, 0, 'L', $fill);
            $this->Cell(COL_WIDTH[5], ROW_HEIGHT, number_format($row->{"day_word_count"}), $border, 0, 'R', $fill);
            $this->Ln();
            $lineCtr++;

            if ($lineCtr == ROWS_PER_PAGE) {
                $this->Cell(COL_WIDTH[0], FOOTNOTE_HEIGHT, "", 0, 0, 'L');
                $this->setFont('', 'I', 0);
                $this->Cell(0, FOOTNOTE_HEIGHT, FOOTNOTE_TEXT, 0, 0, 'L');
                $this->setFont('', '', 0);
            }

            $fill = !$fill;
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

$pdf = new PDF('P', 'in', 'Letter');
$pdf->SetDrawColor(0, 0, 0);
$pdf->SetFont('Arial', '', 10);
$pdf->SetMargins(LEFT_MARGIN, TOP_MARGIN, RIGHT_MARGIN);
$pdf->AddPage();

# load the plan and print it
$plan = json_decode( file_get_contents( "plan.json") );
$pdf->printPlan( $plan );
$pdf->Output();

?>