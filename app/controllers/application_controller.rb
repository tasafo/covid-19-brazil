class ApplicationController < ActionController::Base
  before_action :load_main

  def load_main
    @brazil = Country.find_by(name: 'Brazil')
    @states = State.all.order_by(cases: :desc)
    @cities = City.all.order_by(confirmed: :desc)
    @total_confirmed = @brazil.confirmed
    @deaths = @brazil.deaths
    @recovered = @brazil.recovered
  end
end
