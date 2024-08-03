select * 
from `project Portfolio`.covid_deaths
where continent is not null
order by 3, 4;


-- select * 
-- from `project Portfolio`.vacinated
-- order by 3, 4;
select location , date , total_cases , new_cases , total_deaths , population
from `project Portfolio`.covid_deaths
order by 1,2;

select location , date , total_cases , total_deaths , (total_deaths / total_cases) * 100 as DeathPercentage
from `project Portfolio`.covid_deaths
where location like "%states"
order by 1,2;


select location , date , population, total_cases ,  (total_cases / population) * 100 as percent_population_infected
from `project Portfolio`.covid_deaths
where location like "%states"
order by 1,2;

select location , population, max(total_cases) as highest_infections ,  max(total_cases / population) * 100 as percent_population_infected
from `project Portfolio`.covid_deaths
-- where location like "%states"
group by location , population
order by percent_population_infected desc;



select location , max(total_deaths) as total_death_count
from `project Portfolio`.covid_deaths
where continent is not null
-- where location like "%states"
group by location
order by total_death_count desc;

  
select continent , max(total_deaths) as total_death_count
from `project Portfolio`.covid_deaths
where continent is not null
-- where location like "%states"
group by continent
order by total_death_count desc;


-- GLOBAL NUMBERS

SELECT date, 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM `project Portfolio`.covid_deaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;



SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM `project Portfolio`.covid_deaths
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1, 2;


select dea.continent ,dea.location , dea.date , population , vac.new_vaccinations
from `project Portfolio`.covid_deaths dea
join `project Portfolio`.vacinated vac
	on dea.location = vac.location and 
    dea.date = vac.date
order by 2,3;


SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations, 
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVacinated
       -- ,(RollingPeopleVacinated/population)*100
FROM `project Portfolio`.covid_deaths dea
JOIN `project Portfolio`.vacinated vac
   ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;




with popVSvac 
as (
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations, 
       SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVacinated
       
FROM `project Portfolio`.covid_deaths dea
JOIN `project Portfolio`.vacinated vac
   ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3
)
select *,(RollingPeopleVacinated/population)*100 as percentage_of_people_vacinated
from popVSvac;


CREATE VIEW `project Portfolio`.totalDeaths AS
SELECT continent, MAX(total_deaths) AS total_death_count
FROM `project Portfolio`.covid_deaths
WHERE continent IS NOT NULL
-- WHERE location LIKE "%states"
GROUP BY continent
ORDER BY total_death_count DESC;