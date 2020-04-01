class HomeController < ApplicationController
  def index
    @cases_by_date = CasesByDate.all.order_by(date: :asc)
  end
end
