class CitiesController < ApplicationController
  def index
    @state = State.find_by(uf: params[:state_id].upcase)
    @cities = City.where(uf: @state.uf).order_by(confirmed: :desc)
    @deaths_total = @cities.sum(:deaths)
    @confirmed_total = @cities.sum(:confirmed)
  end

  def show
    @city = City.find_by(uf: params[:state_id].upcase, slug: params[:slug])
    @cases_by_date = @city.log.sort_by { |log| log['date'] }
    @dates = @cases_by_date.map { |log| log['date'].to_date.strftime('%d/%m/%y') }
    @confirmed = @cases_by_date.map { |log| log['confirmed'] }
    @city_deaths = @cases_by_date.map { |log| log['deaths'] }
  end
end
