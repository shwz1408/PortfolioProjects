SELECT * from
PortfolioProject.dbo.Covid_Deaths
order by 3,4
--where location like '%States%'

SELECT * from
Covid_Vaccinations
order by 3,4

-- select data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from Covid_Deaths
order by 1,2

--looking at Total cases vs Total Deaths
--shows likelihoood of dying if you contract covid in your country
select location, date, total_cases,total_deaths, round((total_deaths/total_cases)*100,2) as DeathPercentage
from Covid_Deaths
where location like '%States%'
order by 1,2

--Looking at Total cases vs Population
-- shows what percentage of population got covid
select location, date, total_cases, population, round((total_cases/population)*100,2) as PercentPopulationInfected
from Covid_Deaths
where location like '%States%'
order by 1,2

-- Looking at countries with Highest Infection Rate compared to Population
select location, continent, population, MAX(total_cases) as HighestInfectionCount, round((MAX(total_cases)/population)*100,2) as MaxPercentPopulationInfected
from Covid_Deaths
--where location like '%States%'
group by location,population, continent
order by MaxPercentPopulationInfected DESC


-- Showing continents with Highest Death Count per Population
-- Let's break things by continent
select location, MAX(CAST(total_deaths as int)) as HighestDeathCount
from Covid_Deaths
--where location like '%States%'
where continent is null
group by location
order by HighestDeathCount DESC

-- GLOBAL NUMBERS
select /*date*/ sum(new_cases) as total_cases_a, SUM(CAST(new_deaths as bigint)) as total_deaths_a, round((SUM(CAST(new_deaths as bigint))/sum(new_cases))*100,2) as death_percentage
from Covid_Deaths
where continent is not null
--group by date
order by 1,2