class CasesByDate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, type: Date
  field :cases, type: Integer, default: 0
  field :deaths, type: Integer, default: 0
  field :suspects, type: Integer, default: 0

  index({ date: 1 }, { background: true })

  def self.setup
    covid = Api::Covid19Brazil.new

    today = Date.parse(Time.zone.now.strftime('%Y-%m-%d'))

    initial_date = CasesByDate.count.zero? ? Date.parse('2020-02-25') : today

    date_range = (initial_date..today).map { |d| d.strftime('%Y-%m-%d') }

    date_range.each do |date|
      cases = covid.by_date(date)

      day = 0
      while cases.empty? do
        prior_date = (Date.parse(date) - day += 1).to_s
        cases = covid.by_date(prior_date)
      end

      cases_by_date = CasesByDate.find_by(date: date)

      total = cases.sum { |h| h['cases'] }
      deaths = cases.sum { |h| h['deaths'] }
      suspects = cases.sum { |h| h['suspects'] }

      updated_params = { cases: total, suspects: suspects, deaths: deaths }

      created_params = { date: date }

      if cases_by_date.present?
        cases_by_date.update!(updated_params)
      else
        CasesByDate.create!(created_params.merge(updated_params))
      end
    end
  end
end
