object functions {

  // quick and easy logger
  def logIt( message: String ): Unit = {
    println( java.time.LocalDateTime.now + s": $message")
  }

}
