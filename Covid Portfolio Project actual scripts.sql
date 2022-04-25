Select *
from PortfolioProject..coviddeaths
order by 3,4


--Select *
--from PortfolioProject..covidvaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
	FRom PortfolioProject..coviddeaths
	Order by 1,2

	--Looking at total cases vs total deaths
	--Shows likelihood of dying if you contract covid
Select location, date, total_cases, total_deaths, (Total_Deaths/total_cases)*100 as deathpercentage
	FRom PortfolioProject..coviddeaths
	Where location like '%states%'
	Order by 1,2

	--Looking at total cases vs population
	--Shows what percentage of population got covid

	Select location, date, total_cases, population, (total_cases/population)*100 as deathpercentage
	FRom PortfolioProject..coviddeaths
	Where location like '%states%'
	Order by 1,2

	--Looking at countries with highest infection rate compared to population.

Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as 
	PercentPopulationInfected
FRom PortfolioProject..coviddeaths
--Where location like '%states%'
	Group By Location, Population
	Order by PercentPopulationInfected desc

	--Total deathcount by country

	
Select location, max(cast(total_deaths as int)) as TotalDeathCount
FRom PortfolioProject..coviddeaths
--Where location like '%states%'
Where continent is not null
	Group By Location
	Order by TotalDeathCount desc

	--Let's breakdown by continent

	
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
FRom PortfolioProject..coviddeaths
--Where location like '%states%'
Where continent is not null
	Group By continent
	Order by TotalDeathCount desc

	--Showing continents with highest death count per population

		
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
FRom PortfolioProject..coviddeaths
--Where location like '%states%'
Where continent is not null
	Group By continent
	Order by TotalDeathCount desc

	--GLOBAL NUMBERS

Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(New_deaths as int))/sum(new_cases)*100 as deathpercentage
	FRom PortfolioProject..coviddeaths
--Where location like '%states%'
Where continent is not null
	Group by date
	Order by 1,2

--Looking at Total Population vs Vaccinations

--Use CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
Join PortfolioProject..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3;
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
(Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
Join PortfolioProject..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3;

Select *, (RollingPeopleVaccinated/Population)*100 
From #PercentPopulationVaccinated

--Creating View to Store Data Later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
Join PortfolioProject..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3;


