class HomeController < ApplicationController
  def index
    @cities = City.all.order_by(confirmed: :desc)
                  .pluck(:confirmed, :coordinates)
    @cases_by_date = CasesByDate.all.order_by(date: :asc)
    @max_confirmed = City.max(:confirmed)
  end
end
