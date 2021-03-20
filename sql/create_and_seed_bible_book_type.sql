drop table if exists bible_book_type;

create table bible_book_type as
select 1 as book_type_id, 'History' as book_type_name, 1 as ord union all
select 2 as book_type_id, 'Wisdom' as book_type_name, 3 as ord union all
select 3 as book_type_id, 'Prophets' as book_type_name, 2 as ord union all
select 4 as book_type_id, 'Gospels' as book_type_name, 4 as ord union all
select 5 as book_type_id, 'Epistles' as book_type_name, 5 as ord union all
select 6 as book_type_id, 'Apocalypse', 6 as ord;

select * from bible_book_type;
