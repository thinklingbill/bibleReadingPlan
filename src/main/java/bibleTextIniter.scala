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
         |)
         |stored as ORC
         |""".stripMargin
    )

    logIt( s"$processName: read in seed data from $inFile")
    spark.read.option("delimiter", "|").csv(inFile)
        .createOrReplaceTempView("t")

    logIt( s"$processName: calculate word count and assign column names")
    // notice collapsing multiple spaces down to one
    val df = spark.sql(
      s"""
         |select _c0 as book_abbr
         |     , cast( _c1 as integer ) as chapter
         |     , cast( _c2 as integer ) as verse
         |     , trim( _c3 ) as verse_text
         |     , size( split( trim( regexp_replace( _c3, ' +', ' ' ) ), ' ' ) ) as word_count
         |  from t
         |""".stripMargin
    )

    logIt( s"$processName: insert data into $schema.$table")
    df
      .write
      .mode( "append")
      .insertInto( s"$schema.$table")
  }
}
