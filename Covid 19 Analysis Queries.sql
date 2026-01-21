use portfolioproject ;
select * 
from `Covid19 deaths`;

select * 
from `coviddeath vaccinations`;

-- 1.  Total cases vs Total death and Death Percentage

Select SUM(new_cases) as total_cases, SUM(new_deaths)  as  total_deaths, SUM(new_deaths) / SUM(New_Cases)*100 as DeathPercentage
from `Covid19 deaths`
-- Where location like '%states%'
where continent is not null 
-- Group By date
order by 1,2
;


-- 2. Total COVID-19 Deaths by Continent 


Select location, SUM(new_deaths) as TotalDeathCount
From `Covid19 deaths`
-- Where location like '%states%'
Where continent is not null 
and location  in ('europe', 'Asia', 'Africa', 'North America', 'South America', 'Oceania') 
Group by location
order by TotalDeathCount desc;


-- 3. Percentage of Population Infected by COVID-19 (Country-Wise)

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `Covid19 deaths`
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;


-- 4. Daily COVID-19 Infection Rate by Country

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max(total_cases)/(population)*100 as PercentPopulationInfected
From `Covid19 deaths`
-- Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc;


-- 5. Top 10 Countries by Death Rate (Severity) 
SELECT 
    location,
    population,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND(MAX(total_deaths) / MAX(total_cases) * 100, 2) AS death_rate_percent
FROM `Covid19 Deaths`
WHERE continent IS NOT NULL
GROUP BY location, population
HAVING MAX(total_cases) > 100000
ORDER BY death_rate_percent DESC
LIMIT 10;

-- 6. Vaccination Coverage by Continent

SELECT
    dea.continent,
    MAX(vac.people_fully_vaccinated) AS fully_vaccinated,
    SUM(DISTINCT dea.population) AS population,
    ROUND(
        MAX(vac.people_fully_vaccinated) 
        / SUM(DISTINCT dea.population) * 100, 2
    ) AS percent_fully_vaccinated
FROM `Covid19 deaths` dea
JOIN `Coviddeath Vaccinations` vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent
ORDER BY percent_fully_vaccinated DESC;

-- 7. Countries with Highest Infection Percentage

SELECT
    location,
    population,
    MAX(total_cases) AS total_cases,
    ROUND(MAX(total_cases) / population * 100, 2) AS percent_infected
FROM `Covid19 Deaths`
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percent_infected DESC
LIMIT 10;

