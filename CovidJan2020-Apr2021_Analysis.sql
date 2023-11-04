SELECT * 
FROM covid_deaths
ORDER BY 3,4;

SELECT *
FROM covid_vaccinations 
ORDER BY 3,4;


SELECT location, date,total_cases,new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2;

/* Total Cases VS Total Deaths*/

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as percentage_deaths 
FROM covid_deaths
ORDER BY 1,2;

/* Total Cases VS Total Deaths for period jan/2020 to april/2021 */
SELECT DISTINCT(location) as america_locations FROM covid_deaths
WHERE CONTINENT='South America' OR CONTINENT='North America'


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_deaths
FROM covid_deaths
WHERE location='United States'
ORDER BY 2;


/* Total Cases VS Total Deaths for period jan/2020 to april/2021 */
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_deaths
FROM covid_deaths
WHERE location LIKE '%India%'
ORDER BY 2;

/* Total case VS Population
America: Covid could hit 9 % population by the end of April/2021
India: Covid could hit 1.4 % population by the end of April/2021 */*/
SELECT location, date, total_cases, population, (total_cases/population)*100 as case_percentage
FROM covid_deaths
WHERE location='United States'
ORDER BY 2;

SELECT location, date, total_cases, population, (total_cases/population)*100 as case_percentage
FROM covid_deaths
WHERE location='India'
ORDER BY 2;

/* countried with hightest infection rate*/
SELECT location, MAX(total_cases) AS maximun_cases, population, (MAX(total_cases)/population)*100 as percentage_population_affected, max(total_deaths) AS total_deaths
FROM covid_deaths
GROUP BY location,population
HAVING (MAX(total_cases)/population)*100 IS NOT NULL
ORDER BY 4 DESC; 

/* showing countries with highest death count with population */

SELECT location, MAX(total_deaths) as TotalNumberOfDeaths, population, (MAX(total_deaths)/population)* 100 AS percentageDeath
FROM covid_deaths
GROUP BY location, population
HAVING (MAX(total_deaths)/population)*100 IS NOT NULL
ORDER BY 4 DESC;

SELECT location, MAX(total_deaths) as TotalNumberOfDeaths
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_deaths) IS NOT NULL
ORDER BY TotalNumberOfDeaths DESC;


/* Let's break things down by continent */

SELECT continent, MAX(total_deaths) as TotalNumberOfDeaths
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
HAVING MAX(total_deaths) IS NOT NULL
ORDER BY TotalNumberOfDeaths DESC;


/* GLOBAL NUMBERS*/

WITH CTE AS
(SELECT location, TO_CHAR(date, 'Month') as month_name, SUM(new_cases) AS total_case_thismonth, SUM(new_deaths) AS total_deaths_thismonth
FROM covid_deaths
WHERE EXTRACT(YEAR FROM date)= 2020
GROUP BY location,TO_CHAR(date, 'Month') 
HAVING SUM(new_deaths) IS NOT NULL
),
CTM AS(
SELECT *, RANK() OVER (PARTITION BY location ORDER BY total_deaths_thismonth DESC) AS rankwise
FROM CTE
)
SELECT * FROM CTM
WHERE rankwise<=3;

SELECT * FROM covid_vaccinations;

/*Total Population VS Vaccination*/

WITH PopvsVac as(
SELECT de.continent,de.location, de.date,de.population, va.new_vaccinations
, SUM(new_vaccinations) OVER(PARTITION BY de.location ORDER BY de.location, de.date) as RollingPeopleVaccinated
FROM covid_deaths AS de
JOIN covid_vaccinations AS va
ON de.location=va.location and de.date=va.date
WHERE de.continent IS NOT NULL AND new_vaccinations IS NOT NULL


)
SELECT * ,(RollingPeopleVaccinated/population)*100 AS percentage_vaccinated
FROM PopvsVac 


