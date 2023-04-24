
--1.Select Data that we are going to be using


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

--2.Looking at Total Cases vs Total Deaths

--2.a)These columns has nvarchar data type so we need to modify it for computing the percentage.
alter table CovidDeaths$
alter column total_deaths float

alter table CovidDeaths$
alter column total_cases float

--Shows likelyhood of dying from covid in United States
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

--Looking aat Total Cases vs Population
--Shows what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
From PortfolioProject..CovidDeaths$
--where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to population
Select Location,Max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--where location like '%states%'
group by Location, Population
order by PercentPopulationInfected desc


--Showing continents with Highest Death Count per Population
Select continent,Max(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select   sum(new_cases)as total_cases,
sum(new_deaths)as total_deaths,  
sum(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
,dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
		ON dea.location = vac.location
		and dea.date = vac.date
where dea.continent  is not null 
and vac.new_vaccinations is not null
order by 2,3

--USING CTE

With PopVsVac(Continent, Location, Date, Population, 
New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
,dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
		ON dea.location = vac.location
		and dea.date = vac.date
where dea.continent  is not null 
and vac.new_vaccinations is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac


--USING A TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
,dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
		ON dea.location = vac.location
		and dea.date = vac.date
where dea.continent  is not null 
and vac.new_vaccinations is not null

Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From #PercentPopulationVaccinated



--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated AS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location
,dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
		ON dea.location = vac.location
		and dea.date = vac.date
where dea.continent  is not null;


Select * 
From PercentPopulationVaccinated
