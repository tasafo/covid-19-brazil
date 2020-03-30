class HomeController < ApplicationController
  def index
    @brazil = Country.find_by(name: 'Brazil')
    @states = State.all
    @total_confirmed = @brazil.confirmed
    @deaths = @brazil.deaths
    @recovered = @brazil.recovered
    @cases_by_date = CasesByDate.all.order_by(date: :asc)
  end
end
