-- Covid_19 Data Exploration 

-- Data Resource: https://ourworldindata.org/covid-deaths

-- Skills Used: Basic Select, Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

Select *
From CovidDeaths
Where Continent is not null 
Order by 3,4


-- Select data that we'll use 
Select Location, Date, Total_cases, New_cases, Total_deaths, Population
From CovidDeaths
Where Continent is not null 
Order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in United States 
Select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
From CovidDeaths
Where Location like '%states%'
and Continent is not null 
Order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, Date, Population, Total_cases,  (Total_cases/Population)*100 as PercentPopulationInfected
From CovidDeaths
Order by 1,2


-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(Total_cases) as HighestInfectionCount,  Max((Total_cases/Population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
Order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population
Select Location, MAX(Convert(Total_deaths, Signed)) as TotalDeathCount
From CovidDeaths
Where Continent is not null 
Group by Location
Order by TotalDeathCount desc


-- Total Death in each Continent 
-- Showing contintents with the highest death count per population
Select Continent, MAX(convert(Total_deaths, Signed)) as TotalDeathCount
From CovidDeaths
Where Continent is not null 
Group by Continent
Order by TotalDeathCount desc


-- Global Numbers
Select SUM(New_cases) as Total_cases, SUM(Convert(New_deaths, Signed)) as Total_deaths, SUM(Convert(New_deaths, Signed))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
Where Continent is not null 
Order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations
, SUM(CONVERT(vac.New_vaccinations, Signed)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.Location = vac.Location
	and dea.Date = vac.Date
Where dea.Continent is not null 
Order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 