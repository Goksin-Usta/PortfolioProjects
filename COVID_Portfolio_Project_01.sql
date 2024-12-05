Select *
From PortfolioProject..lllCovidDeaths

Select *
From PortfolioProject..csvCovidVaccinations

Select *
From PortfolioProject..lllCovidDeaths
where continent is not null
order by 3,4

-- select data that we are going to be using
-- looking at total cases vs total deaths
Select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..lllCovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2

--loking at total cases vs population
--Shows what percentage of population got covid

Select location, date,population,total_cases,(total_cases/population)*100 as PercentPopulaionInfected
From PortfolioProject..lllCovidDeaths
--Where location like '%states%'
order by 1,2

--Looking at countries with hihestýnfection rate compared to population
Select location, population, MAX(total_cases) AS highestInfectionCount,(MAX(total_cases/population))*100 as PercentPopulaionInfected
From PortfolioProject..lllCovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentPopulaionInfected desc

-- showing countries with highest death count per population
Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..lllCovidDeaths
--Where location like '%Turkey%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- Let's break thýngs down by contýnent

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..lllCovidDeaths
--Where location like '%Turkey%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- showing contintents with the highest death count per population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..lllCovidDeaths
--Where location like '%Turkey%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers

Select  date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..lllCovidDeaths
--Where location like '%states%'
Where continent is not null
Group By date
order by 1,2

-- looking at total population vs vaccinations
with PopvsVac(Continent, location,date,population,new_vaccinations,RollingPeopleVaccinated) AS 
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortfolioProject..lllCovidDeaths dea
Join PortfolioProject..csvCovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
SELECT * ,(RollingPeopleVaccinated/population) *100
FROM PopvsVac
order by 2,3
-- Use cte

--TEMP TABLE
-- TABLODA DEÐÝÞÝKLÝK YAPTIYSAN
-- DROP TABLE if exists #PercentPopulationVaccinated
CREATE table #PercentPopulationVaccinated
( 
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortfolioProject..lllCovidDeaths dea
Join PortfolioProject..csvCovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

SELECT * ,(RollingPeopleVaccinated/population) *100
FROM #PercentPopulationVaccinated
order by 2,3