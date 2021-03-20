drop table if exists bible_book;

create table bible_book (
 book_id  integer
,book_name  varchar(100)
,book_type_id integer
,testament_id integer
,chapters integer
);