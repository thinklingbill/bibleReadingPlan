select bp.day_id as day
      ,bb.book_name
      ,bp.start_chapter
      ,bp.start_verse
      ,bp.end_chapter
      ,bp.end_verse
      ,bbt.book_type_name
from bible_plan bp
join bible_book bb on bb.book_id = bp.book_id
join bible_book_type bbt on bbt.book_type_id = bb.book_type_id
order by 
     bp.day_id
	,bb.testament_id
    ,bbt.ord
    ,bb.book_id
    ;
