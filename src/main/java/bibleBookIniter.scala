import org.apache.spark.sql.SparkSession
import functions._

// initializes/loads the bible book table
object bibleBookIniter {
  def initBibleBook(spark: SparkSession
                    , schema: String
                    , table: String
                    , inFile: String): Unit = {

    val processName = "initBibleBook"

    logIt(s"$processName: drop and recreate $schema.$table")
    spark.sql(s"drop table if exists $schema.$table")

    spark.sql(
      s"""
         |create table $schema.$table (
         |   book_abbr       string
         |  ,book_ord        integer
         |  ,book_name       string
         |  ,category_abbr   string
         |)
         |stored as ORC
         |""".stripMargin
    )

    logIt(s"$processName: read in seed data from $inFile")
    val d = spark.read.option("delimiter", "|").csv(inFile)
      .createOrReplaceTempView("t")

    logIt(s"$processName: assign column names")
    val df = spark.sql(
      s"""
         |select _c0 as book_abbr
         |     , row_number() over ( order by 1 ) as book_ord
         |     , _c1 as book_name
         |     , _c2 as book_category
         |  from t
         |""".stripMargin
    )

    logIt(s"$processName: insert data into $schema.$table")
    df
      .write
      .mode("append")
      .insertInto(s"$schema.$table")

    logIt(s"$processName: Create category table")

    spark.sql(s"drop table if exists $schema.${table}_category")

    spark.sql(
      s"""
         |create table $schema.${table}_category (
         |   category_abbr   string
         |  ,category_ord    integer
         |  ,category_name   string
         |)
         |stored as ORC
         |""".stripMargin
    )

    logIt(s"$processName: Populate the category table")
    val catDf = spark.sql(
      s"""
         |select distinct
         |       bb.category_abbr
         |      ,case bb.category_abbr
         |            when 'OT' then 1
         |            when 'W'  then 2
         |            when 'NT' then 3
         |            else 4 end as category_ord
         |      ,case bb.category_abbr
         |            when 'OT' then 'Old Testament History and Prophecy'
         |            when 'W'  then 'Old Testament Wisdom and Writings'
         |            when 'NT' then 'New Testament'
         |            else 'Unknown Category' end as category_name
         |  from $schema.$table bb
         |""".stripMargin
    )

    logIt(s"$processName: insert data into $schema.$table")
    catDf
      .write
      .mode("append")
      .insertInto(s"$schema.${table}_category")

    spark.sql( s"select * from $schema.$table order by book_ord").show()

    spark.sql( s"select * from $schema.${table}_category order by category_ord").show()

  }
}
