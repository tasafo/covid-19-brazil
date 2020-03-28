class HomeController < ApplicationController
  def index
    @states = State.all
    @total_confirmed = @states.sum(&:confirmed)
    @deaths = @states.sum(&:deaths)
  end
end
