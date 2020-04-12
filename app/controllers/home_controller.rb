class HomeController < ApplicationController
  def index
    @cases_by_date = CasesByDate.all.order_by(date: :asc)
    @max_confirmed = City.max(:confirmed)
  end
end
