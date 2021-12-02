select * 
from PorfolioProject..CovidDeaths
order by 3,4


select location, date , total_cases,new_cases,total_deaths, population
from PorfolioProject..CovidDeaths
order by 1,2


-- Number of Cases to Total Deaths
select location, date , total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
--where location like '%Ghana%'
order by 1,2


--- Total cases vs Population
select location, date , total_cases,population, (total_cases/population)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
--where location like '%ghana%'
order by 1,2

-- Highest Infection rates
select location ,population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PopulationInfectionPercent
from PorfolioProject..CovidDeaths
group by location,population
order by 4 desc 


--- Highest Death Count per Population
--Since Continent total and Income are added, they are removed
select location , max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is not null
group by location
order by 2 desc

--- Highest Death Count per Continent
--Since Continent total and Income are added, they are removed
select location , max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is null
group by location
order by 2 desc

select continent , max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is not null
group by continent
order by 2 desc


--- Global Percentages
select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercent
from PorfolioProject..CovidDeaths
where continent is not null --and location is not null
group by date
order by 1,2


select  sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercent
from PorfolioProject..CovidDeaths
where continent is not null
order by 1,2


----Population vs Vacination Totals

select deaths.continent,deaths.location,deaths.date,deaths.population,vacinations.new_vaccinations ,
sum(convert(bigint,vacinations.new_vaccinations )) over (partition by deaths.location order by deaths.location,deaths.date) as CumVacinationByCountry -- sums only over countries -- orderby returns cummulative sum
from PorfolioProject..CovidDeaths deaths
join PorfolioProject..CovidVacinations vacinations
on deaths.location = vacinations.location
and deaths.date = vacinations.date
where deaths.continent is not null --and deaths.location='Albania'
order by 2,3


-- USE CTE

with Pop_V_Vac (continent,location,date,population,new_vaccinations,CumVacinationByCountry)
as 
(
select deaths.continent,deaths.location,deaths.date,deaths.population,vacinations.new_vaccinations ,
sum(convert(bigint,vacinations.new_vaccinations )) over (partition by deaths.location order by deaths.location,deaths.date) as CumVacinationByCountry -- sums only over countries -- orderby returns cummulative sum
from PorfolioProject..CovidDeaths deaths
join PorfolioProject..CovidVacinations vacinations
on deaths.location = vacinations.location
and deaths.date = vacinations.date
where deaths.continent is not null
--order by 2,3
)
select *,(CumVacinationByCountry/population)*100 as PercentageVaccinated	--Cummulative population percentage
from Pop_V_Vac
where (CumVacinationByCountry/population) is not null						-- clean data to remove null values


-- using temp tables
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CumVacinationByCountry numeric
)

Insert into #PercentPopulationVaccinated
select deaths.continent,deaths.location,deaths.date,deaths.population,vacinations.new_vaccinations ,
sum(convert(bigint,vacinations.new_vaccinations )) over (partition by deaths.location order by deaths.location,deaths.date) as CumVacinationByCountry -- sums only over countries -- orderby returns cummulative sum
from PorfolioProject..CovidDeaths deaths
join PorfolioProject..CovidVacinations vacinations
on deaths.location = vacinations.location
and deaths.date = vacinations.date
where deaths.continent is not null

select *,(CumVacinationByCountry/population)*100 as PercentageVaccinated	--Cummulative population percentage
from #PercentPopulationVaccinated
where (CumVacinationByCountry/population) is not null						-- clean data to remove null values


--

create view PercentPopulationVaccinated as 
select deaths.continent,deaths.location,deaths.date,deaths.population,vacinations.new_vaccinations ,
sum(convert(bigint,vacinations.new_vaccinations )) over (partition by deaths.location order by deaths.location,deaths.date) as CumVacinationByCountry -- sums only over countries -- orderby returns cummulative sum
from PorfolioProject..CovidDeaths deaths
join PorfolioProject..CovidVacinations vacinations
on deaths.location = vacinations.location
and deaths.date = vacinations.date
where deaths.continent is not null





