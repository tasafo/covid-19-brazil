class HomeController < ApplicationController
  def index
    @cases_by_date = CasesByDate.all.order_by(date: :asc)
    @deaths_by_uf = City.deaths_by_uf
  end
end
