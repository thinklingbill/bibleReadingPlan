import org.apache.spark.sql.SparkSession
import functions._

// initializes/loads the bible book table
object bibleBookIniter {
  def initBibleBook(spark: SparkSession
                    , schema: String
                    , table: String
                    , inFile: String): Unit = {

    val processName = "initBibleBook"
    
    logIt( s"$processName: drop and recreate $schema.$table")
    spark.sql(s"drop table if exists $schema.$table")

    spark.sql(
      s"""
         |create table $schema.$table (
         |   book_abbr       string
         |  ,book_name       string
         |  ,book_category   string
         |)
         |stored as ORC
         |""".stripMargin
    )

    logIt( s"$processName: read in seed data from $inFile")
    val d = spark.read.option("delimiter", "|").csv(inFile)
      .createOrReplaceTempView("t")

    logIt( s"$processName: assign column names")
    val df = spark.sql(
      s"""
         |select _c0 as book_abbr
         |     , _c1 as book_name
         |     , _c2 as book_category
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
