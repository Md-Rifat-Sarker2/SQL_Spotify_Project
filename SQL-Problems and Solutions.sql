--Advance SQL Project -- Spotify Dataset

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify;


--EDA
select Count(*) from spotify;

select Count(distinct artist) from spotify;

select count(distinct album) from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify
where duration_min = 0;

delete from spotify 
where duration_min = 0;

select distinct channel from spotify;

-- ---------------------------------------
-- Problem and solutions
-- ---------------------------------------

--Task - 1: Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where stream > 1000000000;

--Task - 2: List all albums along with their respective artists.
select 
	distinct album,
	artist
from spotify
order by 1;

--Task - 3: Get the total number of comments for tracks where licensed = TRUE.
select 
	sum(comments) as total_comments
from spotify
where licensed = true;

--Task - 4: Find all tracks that belong to the album type single.
select * from spotify
where album_type ilike 'single';

--Task - 5: Count the total number of tracks by each artist.
select 
	artist,
	count (*) as total_records
from spotify
group by 1
order by 2 desc;

--Task - 6: Calculate the average danceability of tracks in each album.
select 
	album,
	avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc;

--Task - 7: Find the top 5 tracks with the highest energy values.
select 
	track,
	max(energy)
from spotify
group by 1
order by 2 desc
limit 5;

--Task - 8: List all tracks along with their views and likes where official_video = TRUE.
select 
	track,
	sum(views) as total_viwes,
	sum(likes) as total_likes
from spotify
where official_video = true
group by 1
order by 2 desc,3 desc;

--Task - 9: For each album, calculate the total views of all associated tracks.
select 
	album,
	track,
	sum(views) as total_views
from spotify
group by 1,2
order by 3 desc;

--Task - 10: Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from 
(select 
	track,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as stream_on_youtube,
	coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as stream_on_spotify
from spotify
group by 1) as t1
where stream_on_spotify>stream_on_youtube
and stream_on_youtube <>0

--Task - 11: Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist
as
(
select 
	artist,
	track,
	sum(views) as total_views,
	dense_rank() over(partition by artist order by sum(views) desc) as rank 
from spotify
group by 1,2
order by 1,3 desc
)
select * from ranking_artist
where rank <=3
	and total_views <>0;
	
--Task - 12: Write a query to find tracks where the liveness score is above the average.
select 
	artist,
	track,
	liveness
from spotify
where liveness > (select avg(liveness) from spotify);

--Task - 13: Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH engergy_table
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM engergy_table
ORDER BY 2 DESC











