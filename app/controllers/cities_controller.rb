class CitiesController < ApplicationController
  before_action :validate_previous_steps!

  def index
    @selected_country_name = session['search']['country']
    @selected_score_nomad  = session['search']['score_nomad'].to_i

    @cities = City.where(country: @selected_country_name).
      where("score_nomad >= #{@selected_score_nomad}").
      order(:name)
  end

  private

  def validate_previous_steps!
    # step 1 validation
    countries   = session['search']['countries'] if session['search']
    step1_valid = countries.present? && countries.size == 3

    unless step1_valid
      flash[:notice] = "Let's start from the first step"
      redirect_to cities_search_step1_path
    end

    # step 2 validation
    step2_valid = session['search']['country'].present?

    unless step2_valid
      flash[:notice] = "Let's go back to the second step"
      redirect_to cities_search_step2_path
    end

    # step 3 validation
    step3_valid = session['search']['score_nomad'].present?

    unless step3_valid
      flash[:notice] = "Let's go back to the third step"
      redirect_to cities_search_step3_path
    end
  end
end
