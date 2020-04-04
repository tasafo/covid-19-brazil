class HomeController < ApplicationController
  def index
    @deaths_by_uf = [['State', 'Views']]
    @cities = City.all.group_by {|city| city.uf}
    @cities.each do |uf,cities|
      # puts "#{uf} - #{cities.sum { |c| c.deaths_by_uf }}"  
      @deaths_by_uf << ["BR-#{uf}",cities.sum { |c| c.deaths }]
    end
    @cases_by_date = CasesByDate.all.order_by(date: :asc)
  end
end
