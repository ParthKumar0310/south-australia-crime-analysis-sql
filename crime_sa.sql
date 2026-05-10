use south_australia_crimestatistics;
create table crime_fact(
reported_date date,
subrub varchar(50),
postcode bigint,
offence_level1 varchar(100),
offence_level2 varchar(100),
offence_level3 varchar(100),
offence_count bigint
);
select count(*) from crime_fact;
select * from crime_fact limit 5;

CREATE TABLE suburbs (
    suburb_id INT AUTO_INCREMENT PRIMARY KEY,
    suburb VARCHAR(50),
    postcode BIGINT
);

CREATE TABLE offences(
    offence_id INT AUTO_INCREMENT PRIMARY KEY,
    offence_level_1 VARCHAR(100),
    offence_level_2 VARCHAR(100),
    offence_level_3 VARCHAR(100)
);

CREATE TABLE crime_dataset (
    crime_id INT AUTO_INCREMENT PRIMARY KEY,
    suburb_id INT,
    offence_id INT,
    reported_date DATE,
    offence_count BIGINT,

    FOREIGN KEY (suburb_id) REFERENCES suburbs(suburb_id),
    FOREIGN KEY (offence_id) REFERENCES offences(offence_id)
);


INSERT INTO suburbs (suburb, postcode)
SELECT DISTINCT subrub, postcode
FROM crime_fact;

INSERT INTO offences (offence_level_1, offence_level_2, offence_level_3)
SELECT DISTINCT offence_level1, offence_level2, offence_level3
FROM crime_fact;


insert into crime_dataset(
suburb_id,
offence_id,
reported_date,
offence_count)
select
s.suburb_id,
o.offence_id,
cf.reported_date,
cf.offence_count
from crime_fact cf
join suburbs s
on cf.subrub=s.suburb
and cf.postcode=s.postcode
join offences o
on cf.offence_level1=o.offence_level_1
and cf.offence_level2=o.offence_level_2
and cf.offence_level3=o.offence_level_3;

SELECT COUNT(*) as total_suburbs FROM suburbs;
SELECT * FROM offences;
select count(*) as total_crimes from crime_dataset;

-- Highest Total Crime By Suburb 
select sum(cf.offence_count) as total_crimes, suburbs.suburb
from crime_dataset cf
join suburbs
on suburbs.suburb_id=cf.suburb_id
group by suburbs.suburb
order by total_crimes desc;

-- lowest total crimes
select sum(cf.offence_count) as total_crimes, suburbs.suburb
from crime_dataset cf
join suburbs
on suburbs.suburb_id=cf.suburb_id
group by suburbs.suburb
having total_crimes between 1 and 10
order by total_crimes asc;

-- most common crime category in level 1 by suburbs
select
s.suburb,
sum(case
	when o.offence_level_1="OFFENCES AGAINST PROPERTY"
    then cd.offence_count
    else 0
    end) as property_crimes,
sum(case
	when o.offence_level_1="OFFENCES AGAINST THE PERSON"
    then cd.offence_count
    else 0
    end) as person_crimes,
sum(cd.offence_count) as total_crimes
from crime_dataset cd
join suburbs s
on cd.suburb_id=s.suburb_id
join offences o
on cd.offence_id=o.offence_id
group by s.suburb
order by total_crimes desc;


-- over time analysis
select
o.offence_level_1,
YEAR(cd.reported_date) as Year,
sum(cd.offence_count) as total_crimes
from crime_dataset cd
join offences o
on cd.offence_id=o.offence_id
group by 1,2;

-- crime growth by year
select
offence_level_1,
year,
total_crimes,
lag(total_crimes)
over(partition by offence_level_1 order by year) as previous_year_crime,
total_crimes - LAG(total_crimes) OVER (
        PARTITION BY offence_level_1
        ORDER BY year
    ) AS growth
from
(select
o.offence_level_1,
YEAR(cd.reported_date) as Year,
sum(cd.offence_count) as total_crimes
from crime_dataset cd
join offences o
on cd.offence_id=o.offence_id
group by 1,2) t;


-- crime growth by month
select
offence_level_1,
year,
month,
total_crimes,
lag(total_crimes)
over(partition by offence_level_1 order by year,month) as previous_month_crime,
total_crimes - LAG(total_crimes) OVER (
        PARTITION BY offence_level_1
        ORDER BY month,year
    ) AS growth
from
(select
o.offence_level_1,
YEAR(cd.reported_date) as Year,
month(cd.reported_date) as month,
sum(cd.offence_count) as total_crimes
from crime_dataset cd
join offences o
on cd.offence_id=o.offence_id
group by 1,2,3) t

order by
offence_level_1,
year desc,
month asc;
--

-- top 5 crimes level 2 by suburb
select * from (
select *,row_number() over(partition by suburb order by total_crimes desc) 
as rank_num 
from(
select
s.suburb,
s.postcode,
o.offence_level_2,
sum(cd.offence_count) as total_crimes
from crime_dataset cd
join suburbs s
on cd.suburb_id=s.suburb_id
join offences o
on cd.offence_id=o.offence_id
WHERE s.suburb IS NOT NULL 
AND TRIM(s.suburb) <> ''
group by 1,2,3)t)ranked
where rank_num<=5;

-- hieraraichal level crimes
select
o.offence_level_1,
o.offence_level_2,
sum(case
	when year(cd.reported_date) = 2024
    then cd.offence_count
    else 0
    end) as crimes_2024,
sum(case
	when year(cd.reported_date) = 2025
    then cd.offence_count
    else 0
    end) as crimes_2025,
sum(cd.offence_count) as total_crimes
FROM crime_dataset cd
JOIN offences o
    ON cd.offence_id = o.offence_id

GROUP BY 
    o.offence_level_1,
    o.offence_level_2 WITH ROLLUP;

-- level 3
select
o.offence_level_3,
sum(cd.offence_count) as total_crimes
from crime_dataset cd
join suburbs s
on cd.suburb_id=s.suburb_id
join offences o
on cd.offence_id=o.offence_id
group by 1;

-- percentage contribution
select o.offence_level_1,
sum(cd.offence_count) as total_crimes,
round(sum(cd.offence_count)*100.0/
(select sum(offence_count) from crime_dataset),
2) as crime_percentage

from crime_dataset cd
join offences o
on cd.offence_id = o.offence_id

 group by o.offence_level_1;
 
 -- Top 10 Suburbs Responsible for X% of Crime
select 
s.suburb,sum(cd.offence_count) as total_crimes,
round(sum(cd.offence_count)*100.0/(select sum(offence_count) from crime_dataset),2) as crime_percentage
from crime_dataset cd
join suburbs s on cd.suburb_id=s.suburb_id
where s.suburb is not null and trim(s.suburb)<>''
group by s.suburb
order by total_crimes desc
limit 10;
 
 -- grouping by year and month
 SELECT 
    YEAR(reported_date) AS crime_year,
    MONTH(reported_date) AS crime_month,
    SUM(offence_count) AS total_offences
FROM crime_dataset
GROUP BY 
    YEAR(reported_date),
    MONTH(reported_date)
ORDER BY 
    crime_year,
    crime_month;
 
 
 
 
 
 