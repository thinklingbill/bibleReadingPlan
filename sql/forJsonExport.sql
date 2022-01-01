select bp.day_id
      ,bb.book_id
      ,bb.book_name
	  ,bp.start_chapter
      ,bp.end_chapter
      ,bp.start_verse
      ,bp.end_verse
  from bible_plan bp
  join bible_book bb 
    on bb.book_id = bp.book_id
 order by
       day_id, book_id;