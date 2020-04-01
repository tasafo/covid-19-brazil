class CitiesController < ApplicationController
  def index
    @state = State.find(params[:state_id])
    @cities = City.where(uf: @state.uf)
  end
end
