select *
from CovidDeaths
where continent is not null
order by 3,4 asc


-- 1. Project SQL
--	a. Data Requirement : Covid-Death-2020/2023
--	b. Data Import From Excel To SQL : 1. Covid Deaths, 2. Covid Vaccinations
--	c. Data Exploration : 
--		a. Covid Deaths
		-- Selecting Data that we are going to use
select 
	location,
	date,
	population,
	new_cases,
	total_cases,
	new_deaths,
	total_deaths
from 
	CovidDeaths
where 
	continent is not null
order by
	1, 3 desc

	-- Looking Total Covid Case vs Total Covid Deaths
select 
	location,
	date,
	total_cases,
	total_deaths,
	(cast(total_deaths as decimal)/cast(total_cases as decimal)*100) as DeathPrecentage
from 
	CovidDeaths
where 
	continent is not null
group by
	location,
	date,
	total_cases,
	total_deaths
order by
	1,5

	-- Looking Total Cases vs Population
select 
	location,
	date,
	new_cases,
	new_deaths,
	total_cases,
	population,
	(cast(total_cases as decimal)/cast(population as decimal)*100) as PopulationInvectedPrecentage
from 
	CovidDeaths
where 
	-- location like '%Indonesia%'
	-- and
	continent is not null
group by
	location,
	date,
	new_cases,
	new_deaths,
	total_cases,
	population
order by
	7

	-- Looking at Countries with highest Infection Rate
select
	location,
	population,
	MAX(convert(decimal,total_cases)) as HighestInfecitionCases,
	Max(convert(decimal,total_cases)/CONVERT(decimal,population)*100) as PrecentagePopulationInfected
from
	CovidDeaths
where
	continent is not null
group by
	location,
	population
order by PrecentagePopulationInfected desc

	-- Showing Countries with highest death count per countries

select
	location,
	MAX(cast(total_deaths as decimal)) as TotalHighestDeathCase
	--Max(convert(decimal,total_deaths)/CONVERT(decimal,population)*100) as DeathPercentageCountries
from
	CovidDeaths
where 
	continent != ''
group by
	location
order by TotalHighestDeathCase desc


	-- Showing Contitnent with highest death count per Continent
select
	location,
	MAX(cast(total_deaths as decimal)) as TotalHighestDeathCase
	--Max(convert(decimal,total_deaths)/CONVERT(decimal,population)*100) as DeathPercentageCountries
from
	CovidDeaths
where 
	continent = ''
group by
	location
order by TotalHighestDeathCase desc

	-- Showing Total New Cases and Total New Deaths and avg from both

select
	SUM(CONVERT(decimal, new_cases)) as 'Total New Cases',
	sum(cast(new_deaths as decimal)) as 'Total New Deaths',
	sum(cast(new_deaths as  decimal))/sum(cast(new_cases as decimal)*100) as 'World Wide Death Precentage'
	--Max(convert(decimal,total_deaths)/CONVERT(decimal,population)*100) as DeathPercentageCountries
from
	CovidDeaths
--where 
--	continent != ''
--order by 
--	1,2
