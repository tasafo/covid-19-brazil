class CitiesController < ApplicationController
  def index
    @state = State.find_by(uf: params[:state_id])
    @cities = City.where(uf: @state.uf)
    @deaths_total = @cities.sum(:deaths)
    @confirmed_total = @cities.sum(:confirmed)
  end
end
