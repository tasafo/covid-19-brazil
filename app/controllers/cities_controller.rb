class CitiesController < ApplicationController
  def index
    @state = State.find_by(uf: params[:state_id])
    @cities = City.where(uf: @state.uf)
    @deaths_total = @cities.sum(:deaths)
    @confirmed_total = @cities.sum(:confirmed)
  end

  def show
    @city = City.find params[:id]
    @cases_by_date = @city.city_history.log.reverse.group_by{ |h| h["date"] }
    @dates = @cases_by_date.keys
    @confirmed = @cases_by_date.map { |date, city| city.first["confirmed"] }
    @city_deaths = @cases_by_date.map { |date, city| city.first["deaths"] }
  end
end
