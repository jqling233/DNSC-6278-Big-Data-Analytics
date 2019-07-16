-- reference pig script

-- use wildcard to select all "i" files from s3 (no need to copy to hdfs)
ad = LOAD 's3://bigdatateaching/bigrams/googlebooks-eng-us-all-2gram-20120701-i?' AS (bigram:chararray, year:int, count:int, books:int);

gb = GROUP ad BY bigram;
agb = FOREACH gb GENERATE 
	group AS bigram, 
	(double)SUM(ad.count) AS tot_ct,
	(double)SUM(ad.books) AS tot_books,
	(double)SUM(ad.count)/(double)SUM(ad.books) AS book_average,
	MIN(ad.year) as first_year,
	MAX(ad.year) as last_year,
	COUNT(ad.year) AS years;

X = FILTER agb BY first_year == 1950 AND years == 60;
Y = ORDER X BY book_average DESC, bigram;
Z = LIMIT Y 50;
STORE Z INTO 'i-pig-results' USING PigStorage(',');

