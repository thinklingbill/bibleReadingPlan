import org.apache.spark.sql.SparkSession
import functions._

// initializes/loads the bible book table
object bibleTextIniter {
  def initBibleText(spark: SparkSession
                    , schema: String
                    , table: String
                    , inFile: String): Unit = {

    val processName = "initBibleText"

    logIt( s"$processName: drop and recreate $schema.$table")
    spark.sql(s"drop table if exists $schema.$table")

    spark.sql(
      s"""
         |create table $schema.$table (
         |   book_abbr       string
         |  ,chapter         integer
         |  ,verse           integer
         |  ,verse_text      string
         |  ,word_count      integer
         |  ,word_count_cum_per_book  integer
         |)
         |stored as ORC
         |""".stripMargin
    )

    logIt( s"$processName: read in seed data from $inFile")
    spark.read.option("delimiter", "|").csv(inFile)
        .createOrReplaceTempView("t")

    logIt( s"$processName: calculate word count and assign column names")
    // notice collapsing multiple spaces down to one
    spark.sql(
      s"""
         |select _c0 as book_abbr
         |     , cast( _c1 as integer ) as chapter
         |     , cast( _c2 as integer ) as verse
         |     , trim( _c3 ) as verse_text
         |     , size( split( trim( regexp_replace( _c3, ' +', ' ' ) ), ' ' ) ) as word_count
         |  from t
         |""".stripMargin
    )
        .createOrReplaceTempView("t1")

    logIt( s"$processName: Add cumulative words per book" )
    val df = spark.sql(
      s"""
         |select t1.book_abbr
         |     , t1.chapter
         |     , t1.verse
         |     , t1.verse_text
         |     , t1.word_count
         |     , sum(t1.word_count) over (partition by t1.book_abbr
         |                                   order by t1.chapter, t1.verse
         |                                   rows between unbounded preceding and current row
         |                               ) as word_count_cum_per_book
         |  from t1
         |""".stripMargin
    )

    logIt( s"$processName: insert data into $schema.$table")
    df
      .write
      .mode( "append")
      .insertInto( s"$schema.$table")
  }
}
