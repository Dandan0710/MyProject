-- Queries used for Tableau Project

-- Result 1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as Signed)) as total_deaths, SUM(cast(new_deaths as Signed))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null 
Order by 1,2


-- Result 2
Select location, SUM(cast(new_deaths as Signed)) as TotalDeathCount
From CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc


-- Result 3
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected desc


-- Result 4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
Order by PercentPopulationInfected desc