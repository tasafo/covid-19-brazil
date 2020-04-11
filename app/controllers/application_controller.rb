class ApplicationController < ActionController::Base
  before_action :load_main

  def load_main
    @brazil = Country.find_by(name: 'Brazil')
    @states = State.all
    @cities = City.all
    @total_confirmed = @brazil.confirmed
    @deaths = @brazil.deaths
    @recovered = @brazil.recovered
  end
end
