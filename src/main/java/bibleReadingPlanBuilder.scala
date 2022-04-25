import org.apache.spark.sql.SparkSession
import functions._
import org.apache.spark.sql.types.{DoubleType, IntegerType, StringType, StructField, StructType}

// initializes/loads the bible book table
object bibleReadingPlanBuilder {
  def buildBibleReadingPlan(spark: SparkSession
                            , schema: String
                            , table: String
                            , inFile: String): Unit = {

    val processName = "buildBibleReadingPlan"

    logIt(s"$processName: read in plan data from $inFile")

    // create schema
    val dfSchema = StructType(
      Array(
        StructField("ord", IntegerType, nullable = false),
        StructField("book_abbr", StringType, nullable = false),
        StructField("start_chapter", IntegerType, nullable = false),
        StructField("start_verse", IntegerType, nullable = false),
        StructField("end_chapter", IntegerType, nullable = false),
        StructField("end_verse", IntegerType, nullable = false),
        StructField("operation", StringType, nullable = true)
      )
    )

    // read in the plan
    val df = spark.read
      .format("com.crealytics.spark.excel") // Or .format("excel") for V2 implementation
      //              .option("dataAddress", "'My Sheet'!B3:C35") // Optional, default: "A1"
      .option("header", "true") // Required
      .option("treatEmptyValuesAsNulls", "false") // Optional, default: true
      .option("setErrorCellsToFallbackValues", "true") // Optional, default: false, where errors will be converted to null. If true, any ERROR cell values (e.g. #N/A) will be converted to the zero values of the column's data type.
      .option("usePlainNumberFormat", "false") // Optional, default: false, If true, format the cells without rounding and scientific notations
      .schema(dfSchema) // Optional, default: Either inferred schema, or all columns are Strings
      .load(inFile)

    //    df.printSchema()
        df.show()

    df
      .createOrReplaceTempView("raw_plan")

    logIt( s"$processName: Calculate words to read per entry and the reading order")
    spark.sql(
      s"""
         |select p.ord
         |     , row_number( ) over (partition by p.ord
         |                               order by bbc.category_ord, bb.book_ord
         |                          ) as reading_ord
         |     , p.book_abbr
         |     , p.start_chapter
         |     , p.start_verse
         |     , p.end_chapter
         |     , p.end_verse
         |     , p.operation
         |     , sum( bt.word_count ) as words_to_read
         |  from raw_plan p
         |  join $schema.bible_book bb
         |    on bb.book_abbr = p.book_abbr
         |  join $schema.bible_book_category bbc
         |    on bbc.category_abbr = bb.category_abbr
         |  join $schema.bible_text bt
         |    on bt.book_abbr = p.book_abbr
         |   and bt.chapter between p.start_chapter and p.end_chapter
         |   and bt.verse >= case when bt.chapter = p.start_chapter
         |                        then p.start_verse
         |                        else 0 end
         |   and bt.verse <= case when bt.chapter = p.end_chapter and p.end_verse > 0
         |                        then p.end_verse
         |                        else 100000 end
         | group by
         |       p.ord
         |     , bbc.category_ord
         |     , bb.book_ord
         |     , p.book_abbr
         |     , p.start_chapter
         |     , p.start_verse
         |     , p.end_chapter
         |     , p.end_verse
         |     , p.operation
         |""".stripMargin
    ).createOrReplaceTempView("p1")

    logIt( s"$processName: Calculate the cumulative words to read per book")
   spark.sql(
     s"""
        |select p1.ord
        |     , p1.reading_ord
        |     , p1.book_abbr
        |     , p1.start_chapter
        |     , p1.start_verse
        |     , p1.end_chapter
        |     , p1.end_verse
        |     , p1.operation
        |     , p1.words_to_read
        |     , sum( p1.words_to_read ) over ( partition by p1.book_abbr
        |                                          order by p1.start_chapter, p1.start_verse
        |                                           rows between unbounded preceding and current row
        |                               ) as word_to_read_cum_per_book
        |  from p1
        |""".stripMargin
   )
       .createOrReplaceTempView("plan")

    spark.sql( "select * from plan order by reading_ord").show()

    // run checks
    // for any given check record, see if the theoretical word count
    // up to that record = the word count so far at that record
    // for that book
//    spark.sql(
//      s"""
//         |select bt.book_abbr
//         |     , bt.chapter
//         |     , bt.verse
//         |     , sum( bt.word_count ) as sum_words
//         |  from $schema.bible_text bt
//         |  join (
//         |         select
//         |                p.book_abbr
//         |              , p.end_chapter
//         |              , p.end_verse
//         |           from p
//         |          where operation = 'CHECK'
//         |""".stripMargin
//    ).show()

    //
    //    logIt( s"$processName: calculate word count and assign column names")
    //    // notice collapsing multiple spaces down to one
    //    val df = spark.sql(
    //      s"""
    //         |select _c0 as book_abbr
    //         |     , cast( _c1 as integer ) as chapter
    //         |     , cast( _c2 as integer ) as verse
    //         |     , trim( _c3 ) as verse_text
    //         |     , size( split( trim( regexp_replace( _c3, ' +', ' ' ) ), ' ' ) ) as word_count
    //         |  from t
    //         |""".stripMargin
    //    )
    //
    //    logIt( s"$processName: insert data into $schema.$table")
    //    df
    //      .write
    //      .mode( "append")
    //      .insertInto( s"$schema.$table")
  }
}