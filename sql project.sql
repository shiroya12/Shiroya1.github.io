SELECT * 
FROM portfolioproject.covid;
Order by 3,4

use portfolioproject

SELECT * 
FROM portfolioproject.vaccinations;
Order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths
From covid
order by 1,2

-- looking at total cases vs total deaths
-- chaqnces of succumbing to covid when you contract it
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From covid
WHERE location like '%states%'
order by 1,2

-- looking at countries with the highest infection rate
SELECT Location, Population, MAX(total_cases) AS HighestInfectioncount, MAX(total_cases/population))*100 AS
PercentpopulationInfected
From covid
-- Where location like '%states%'
GROUP BY Location, Population
order by percentpopulationInfected DESC


-- showing countries with Highest Death count per population
SELECT Location, MAX(total_deaths) AS TotalDeathCount
From covid
-- Where location like '%states%'
GROUP BY Location
order by TotalDeathCount DESC



SELECT SUM(New_cases) AS total_cases, SUM(cast(new_deaths as Int) as total_deaths, SUM(cast
(new_deaths as int))/SUM(new_cases)*100 as DeathPerecentage 
FROM covid
-- where location is '%states%'
 WHERE continent is not null
 -- GROUP BY date
Order by 1,2




-- looking at the total population vs vaccination 
select C.Continet, C.location, C.date, C.population, V.new_vaccinations
SUM(CONVERT(int, V.new_vaccinations)) OVER (partition by c.location)
FROM covid AS C
JOIN Vaccinations AS V
    ON C.location = V.location
    and C.date = V.date
WHERE C.contitnent is not null
Order by 2,3 


-- use CTE
WITH popvsC  (Continent, Location, Dte, Population, New_vaccinations, Rollingpeople
as
(
select C.Continet, C.location, C.date, C.population, V.new_vaccinations
SUM(CONVERT(int, V.new_vaccinations)) OVER (partition by c.location order by C.date)
AS RollingPeopleVaccinated
FROM covid AS C
JOIN Vaccinations AS V
    ON C.location = V.location
    and C.date = V.date
WHERE C.contitnent is not null
-- Order by 2,3 
)
SELECT*, (RollinPeopleVaccinated/population)*100
From popvsC


-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert Into 
select C.Continet, C.location, C.date, C.population, V.new_vaccinations,
SUM(CONVERT(int, V.new_vaccinations)) OVER (partition by c.location order by C.date)
AS RollingPeopleVaccinated
FROM covid AS C
JOIN Vaccinations AS V
    ON C.location = V.location
    and C.date = V.date
WHERE C.contitnent is not null
-- Order by 2,3 
SELECT*, (RollinPeopleVaccinated/population)*100
From PercentPopulationVaccinated