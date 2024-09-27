-- ORIOLA, Princess Nicole

# Create Database
CREATE DATABASE SDG4;

# Activate SDG4 Database
USE SDG4;

# Create Tables
CREATE TABLE IF NOT EXISTS world_university_rankings (
	world_rank INT,
    institution VARCHAR(255),
    country VARCHAR(255),
    score DECIMAL(5,2),
    year INT,
    PRIMARY KEY (world_rank, institution, year)
);

CREATE TABLE IF NOT EXISTS world_educational_data (
	country VARCHAR(255),
    youth_15_24_literacy_rate_male INT,
    youth_15_24_literacy_rate_female INT,
    gross_primary_education_enrollment DECIMAL(5,2),
    gross_tertiary_education_enrollment DECIMAL(5,2),
    unemployment_rate DECIMAL(5,2),
    PRIMARY KEY (country)
);

CREATE TABLE IF NOT EXISTS job_placement (
	id INT AUTO_INCREMENT,
    stream VARCHAR(255),
    college_name VARCHAR(255),
    placement_status VARCHAR(40),
    salary DECIMAL(10, 2),
    gpa DECIMAL(3,2),
    PRIMARY KEY (id)
);

SELECT * FROM world_university_rankings;
SELECT * FROM world_educational_data;
SELECT * FROM job_placement;


-- (1) Which institutions in the United States are among the top 100 world ranking the most recent year (based on the dataset)?
SELECT institution, world_rank, score
FROM world_university_rankings
WHERE year = (SELECT MAX(year) FROM world_university_rankings)
AND world_rank <= 100
ORDER BY world_rank;


-- (2) What are the top 20 countries with high average university ranking?
SELECT country, AVG(world_rank) AS average_ranking
FROM world_university_rankings
GROUP BY country
ORDER BY average_ranking ASC
LIMIT 20;


-- (3) What are the average salary of graduates from top universities in the United States (only show the top 5)?
SELECT institution, AVG(salary) AS average_salary
FROM world_university_rankings
INNER JOIN job_placement ON institution = college_name
WHERE world_rank <= 10
GROUP BY institution
ORDER BY average_salary DESC
LIMIT 5;


-- (4) How many graduates from universities ranked in the top 50 in the world have been employed in jobs?
SELECT COUNT(*) AS employed_graduates
FROM job_placement
WHERE college_name IN (
    SELECT institution
    FROM world_university_rankings
    WHERE world_rank <= 50
);


-- (5) What is the average GPA of placed graduates grouped by their field of study (ranked)?
SELECT stream, AVG(gpa) AS average_gpa
FROM job_placement
GROUP BY stream
ORDER BY average_gpa DESC;


-- (6) What are the top 5 countries with the highest average gross tertiary education enrollment rate?
SELECT country, AVG(gross_tertiary_education_enrollment) AS average_tertiary_enrollment
FROM world_educational_data
GROUP BY country
ORDER BY average_tertiary_enrollment DESC
LIMIT 5;


-- (7) What are the fields of study with the highest placement rates?
SELECT stream, COUNT(*) AS total_placed
FROM job_placement
WHERE placement_status = 'Placed'
GROUP BY stream
ORDER BY total_placed DESC
LIMIT 10;


-- (8) What universities in countries with a literacy rate (for both male and female youth aged 15-24) above 95%, and where the university ranks in the top 500 globally?
SELECT w.institution, w.country
FROM world_university_rankings w
INNER JOIN world_educational_data e ON w.country = e.country
WHERE (e.youth_15_24_literacy_rate_male + e.youth_15_24_literacy_rate_female) / 2 > 95
AND w.world_rank <= 500;


-- (9) What is the global average youth literacy rate?
SELECT AVG((youth_15_24_literacy_rate_male + youth_15_24_literacy_rate_female) / 2) AS global_average_literacy_rate
FROM world_educational_data;


-- (10)  Which countries have a higher average youth literacy rate than the global average?
SELECT country, (youth_15_24_literacy_rate_male + youth_15_24_literacy_rate_female) / 2 AS average_literacy_rate
FROM world_educational_data
WHERE (youth_15_24_literacy_rate_male + youth_15_24_literacy_rate_female) / 2 > (
    SELECT AVG((youth_15_24_literacy_rate_male + youth_15_24_literacy_rate_female) / 2)
    FROM world_educational_data
)
ORDER BY average_literacy_rate;
