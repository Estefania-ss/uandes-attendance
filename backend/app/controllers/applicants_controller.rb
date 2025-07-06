class ApplicantsController < ApplicationController
  before_action :set_applicant, only: [:show, :update, :destroy]
  before_action :require_admision!, only: [:create, :update, :destroy]

  def index
    @applicants = Applicant.all
    render json: @applicants
  end

  def show
    render json: @applicant
  end

  def create
    @applicant = Applicant.new(applicant_params)
    if @applicant.save
      render json: @applicant, status: :created
    else
      render json: @applicant.errors, status: :unprocessable_entity
    end
  end

  def update
    if @applicant.update(applicant_params)
      render json: @applicant
    else
      render json: @applicant.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @applicant.destroy
    head :no_content
  end

  private

  def set_applicant
    @applicant = Applicant.find(params[:id])
  end

  def applicant_params
    params.require(:applicant).permit(
      :name, :last_name, :rut, :email, :school, :comuna, 
      :career_interest, :career_interest_2, :candidate_id,
      :graduation_year, :graduation_status, :phone, :region
    )
  end
end
