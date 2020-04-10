class CasesByDate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, type: Date
  field :cases, type: Integer
  field :deaths, type: Integer
  field :suspects, type: Integer

  def self.setup
    covid = Api::Covid19Brazil.new
    initial_date = Date.parse('2020-02-25')
    date_range = (initial_date..Date.today).map{ |d| d.strftime('%Y%m%d') }

    date_range.each_with_index do |date, index|
      cases = covid.by_date(date)

      if cases.empty?
        cases = covid.by_date(date_range[index - 1])
      end

      cases_by_date = CasesByDate.find(date: date)
      total = cases.sum{ |h| h['cases'] }
      deaths = cases.sum{ |h| h['deaths'] }
      suspects = cases.sum{ |h| h['suspects'] }

      c = CasesByDate.create!(
        date: date,
        cases: total,
        suspects: suspects,
        deaths: deaths
      ) unless cases_by_date.present?
    end
  end
end
