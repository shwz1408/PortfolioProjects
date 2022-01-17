-- Looking at Total Population vs Vaccinations
-- USE CTE Common Table Expression
With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
		sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from Covid_Deaths cd
join Covid_Vaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
--order by 2,3
)
select *, round((RollingPeopleVaccinated/Population)*100,2)
from PopvsVac


-- Or by using Temp TABLE, Create table, Insert data and Query the new table data
DROP Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
		sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from Covid_Deaths cd
join Covid_Vaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
--order by 2,3

select *, round((RollingPeopleVaccinated/Population)*100,2)
from #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
		sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from Covid_Deaths cd
join Covid_Vaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
--order by 2,3

select * from
PercentPopulationVaccinated