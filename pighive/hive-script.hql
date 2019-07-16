-- reference hive script
-- the following commands runs "discp" which is a parallel copy operation, which is myuch faster. THis copies S3 files from HDFS
-- hadoop  distcp s3://bigdatateaching/bigrams/googlebooks-eng-us-all-2gram-20120701-r? r-bigrams/

-- create external table to read in raw files
create external table bigrams (
bigram string, 
year int,
count int, 
books int
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t' 
LOCATION  '/user/hadoop/r-bigrams/';

-- create hive table for summary statistics
CREATE  TABLE bigram_summary AS
select bigram,
sum(count) as tot_ct,
sum(books) as tot_books,
sum(count)/sum(books) as book_average,
min(year) as first_year,
max(year) as last_year,
count(*) as years
from bigrams
group by bigram;
Time taken: 282.854 seconds

-- query summary statistics
select * from (
select * from bigram_summary where first_year = 1950 and last_year = 2009 and years = 60 
order by book_average desc, bigram 
limit 50) a
order by book_average, bigram;

-- another option is to do a subquery
select a.* from 
(select bigram,
sum(count) as tot_ct,
sum(books) as tot_books,
sum(count)/sum(books) as book_average,
min(year) as first_year,
max(year) as last_year,
count(*) as years
from bigrams
group by bigram) a
where a.first_year = 1950 and a.last_year = 2009 and a.years = 60 
order by a.book_average desc, a.bigram 
limit 10;


