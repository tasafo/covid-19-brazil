class ApplicationController < ActionController::Base
  before_action :load_main

  def load_main
    @states = State.all.order_by(cases: :desc)
    @brazil = Country.find_by(name: 'Brazil')
  end
end
