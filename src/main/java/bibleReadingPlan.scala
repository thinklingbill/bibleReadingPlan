import functions.logIt
import com.itextpdf.kernel.geom.PageSize
import com.itextpdf.kernel.pdf.{PdfDocument, PdfWriter}
import com.itextpdf.layout.Document
import com.itextpdf.layout.element.Paragraph
import com.itextpdf.layout.element.Cell
import scopt.OParser
import org.apache.spark.sql.SparkSession
import initBibleBook.loadBibleBook
import initBibleText.loadBibleText

object bibleReadingPlan {
  def main(args: Array[String]) = {
    val processName = "main"

    logIt(s"$processName: process started")

    case class Config(
                       schema: String = "default",
                       table: String = "",
                       inFile: String = ""
                     )


    val builder = OParser.builder[Config]
    val parser1 = {
      import builder._
      OParser.sequence(
        programName("scopt"),
        head("scopt", "4.x"),
        // option -f, --foo
        opt[String]('s', "schema")
          .action((x, c) => c.copy(schema = x))
          .text("schema is a string property"),
        opt[String]('t', "table")
          .action((x, c) => c.copy(table = x))
          .text("table is a string property"),
        opt[String]('i', "infile")
          .action((x, c) => c.copy(inFile = x))
          .text("infile is a string property"))
    }

    // OParser.parse returns Option[Config]
    OParser.parse(parser1, args, Config()) match {
      case Some(config) => {
        logIt(s"$processName: starting spark session")
        val spark = SparkSession
          .builder
          .master("local[*]")
          .appName("Spark Test")
          //.config("spark.sql.warehouse.dir", "/opt/spark/spark-warehouse")
          .enableHiveSupport()
          .getOrCreate()

        //            println(spark.sparkContext.getConf.getAll.foreach(println))

        config.table match {
          case "create_schema" => {
            spark.sql(s"create schema ${config.schema}")
          }

          case "bible_book" => loadBibleBook(spark, config.schema, config.table, config.inFile)

          case "bible_text" => loadBibleText(spark, config.schema, config.table, config.inFile)

          case "excel_test" => {
            val df = spark.read
              .format("com.crealytics.spark.excel") // Or .format("excel") for V2 implementation
              //              .option("dataAddress", "'My Sheet'!B3:C35") // Optional, default: "A1"
              .option("header", "true") // Required
              .option("treatEmptyValuesAsNulls", "false") // Optional, default: true
              .option("setErrorCellsToFallbackValues", "true") // Optional, default: false, where errors will be converted to null. If true, any ERROR cell values (e.g. #N/A) will be converted to the zero values of the column's data type.
              .option("usePlainNumberFormat", "false") // Optional, default: false, If true, format the cells without rounding and scientific notations
              .option("inferSchema", "true") // Optional, default: false
              //              .option("addColorColumns", "true") // Optional, default: false
              //              .option("timestampFormat", "MM-dd-yyyy HH:mm:ss") // Optional, default: yyyy-mm-dd hh:mm:ss[.fffffffff]
              //              .option("maxRowsInMemory", 20) // Optional, default None. If set, uses a streaming reader which can help with big files (will fail if used with xls format files)
              //              .option("excerptSize", 10) // Optional, default: 10. If set and if schema inferred, number of rows to infer schema from
              //              .option("workbookPassword", "pass") // Optional, default None. Requires unlimited strength JCE for older JVMs
              //              .schema(myCustomSchema) // Optional, default: Either inferred schema, or all columns are Strings
              .load("sparkTest.xlsx")

            df.printSchema()
            df.show()

          }
          case "pdf_test" => {
            // iTextRenderer version
            //            val inputHTML: File = new File("test.html");
            //
            //            val document = Jsoup.parse(inputHTML, "UTF-8");
            //            document.outputSettings().syntax(Document.OutputSettings.Syntax.xml);
            //
            //            val outputStream = new FileOutputStream("test.pdf")
            //            val renderer = new ITextRenderer();
            //            val sharedContext = renderer.getSharedContext();
            //            sharedContext.setPrint(true);
            //            sharedContext.setInteractive(false);
            //            renderer.setDocumentFromString(document.html());
            //            renderer.layout();
            //            renderer.createPDF(outputStream);

            val pdf = new PdfDocument(new PdfWriter("test.pdf"));
            val document = new Document(pdf, PageSize.A4);
            val line = "Hello! Welcome to iTextPdf";
            document.add(new Paragraph(line));
            document.close();

            println("Awesome PDF just got created.");

            // LOOK HERE FOR BEGINNING OF UNDERSTANDING TABLES/CELLS
            //            https://www.tabnine.com/code/java/classes/com.itextpdf.layout.element.Cell
          }

          case "test"
          => {
            //            spark.sql(
            //              s"""select bb.book_name
            //                       , sum( bt.word_count )
            //                    from bible_reading_plan.bible_text bt
            //                    join bible_reading_plan.bible_book bb on bb.book_abbr = bt.book_abbr
            //                   group by bb.book_name"""
            //            ).show(1000, false)
//            spark.sql("select sum( word_count ) from bible_reading_plan.bible_text").show()
//            spark.sql("select book_abbr, chapter, verse, word_count  from bible_reading_plan.bible_text where book_abbr = 'Jo3' order by chapter, verse").show(1000, false)
            spark.sql(
              s"""
                 |select bb.book_category
                 |     , sum( bt.word_count )
                 |  from bible_reading_plan.bible_book bb
                 |  join bible_reading_plan.bible_text bt
                 |    on bt.book_abbr = bb.book_abbr
                 | group by
                 |       bb.book_category
                 |""".stripMargin
            ).show()
          }
          case _ => {
            throw new Exception(s"unknown table/command in command line arguments: $config.table")
          }
        }
        logIt(s"$processName: closing spark session")
        spark.stop()
      }
      case _ =>
        logIt(s"$processName: WUT?")
      // arguments are bad, error message will have been displayed
    }

    logIt(s"$processName: process ended")
  }
}
