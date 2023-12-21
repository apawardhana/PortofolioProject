-- Data Exploration Part2

-- melihat total vaksinasi dari sebuah populasi

select continent, location
from CovidDeaths
where continent is not null


select
	Dth.continent, Dth.location, Dth.date, 
	Dth.population, cast(Vac.new_vaccinations as int) as New_Vaccinations,
	SUM(New_Vaccinations) over (Partition by Dth.location order by Dth.date) as RollingPeopleVaccinated,
	(RollingPeopleVaccinated/population)*100 as Precentage
from 
	CovidDeaths Dth
join
	CovidVaccinations Vac on 
		Dth.location = Vac.location
		and
		Dth.date = Vac.date
where 
	Dth.continent != ''
	and
	New_Vaccinations != 0
order by 
	5


-- Using CTE

with PopulationVSVaccination (contitnent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select
	Dth.continent, Dth.location, Dth.date, 
	Dth.population, cast(Vac.new_vaccinations as int) as New_Vaccinations,
	SUM(New_Vaccinations) over (Partition by Dth.location order by Dth.date) as RollingPeopleVaccinated
from 
	CovidDeaths Dth
join
	CovidVaccinations Vac on 
		Dth.location = Vac.location
		and
		Dth.date = Vac.date
where 
	Dth.continent != ''
	and
	New_Vaccinations != 0
--order by 
--	5
)

select *, (RollingPeopleVaccinated/population)*100 as Precentage
from PopulationVSVaccination
order by 5


-- Temp Table

drop table if exists #PercentagePopulationVaccinated
create table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population Numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric)

insert into #PercentagePopulationVaccinated
select
	Dth.continent, Dth.location, Dth.date, 
	Dth.population, cast(Vac.new_vaccinations as int) as New_Vaccinations,
	SUM(New_Vaccinations) over (Partition by Dth.location order by Dth.date) as RollingPeopleVaccinated
from 
	CovidDeaths Dth
join
	CovidVaccinations Vac on 
		Dth.location = Vac.location
		and
		Dth.date = Vac.date
where 
	Dth.continent != ''
	--and
	--New_Vaccinations != 0


select *, (RollingPeopleVaccinated/population)*100 as Precentage
from #PercentagePopulationVaccinated



-- membuat view data untuk di gunakan di visualisasi nanti

create view PercentagePopulationVaccinated as
select
	Dth.continent, Dth.location, Dth.date, 
	Dth.population, cast(Vac.new_vaccinations as int) as New_Vaccinations,
	SUM(New_Vaccinations) over (Partition by Dth.location order by Dth.date) as RollingPeopleVaccinated
from 
	CovidDeaths Dth
join
	CovidVaccinations Vac on 
		Dth.location = Vac.location
		and
		Dth.date = Vac.date
where 
	Dth.continent != ''
	--and
	--New_Vaccinations != 0







