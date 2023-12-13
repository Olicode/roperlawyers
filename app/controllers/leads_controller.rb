# app/controllers/leads_controller.rb
class LeadsController < ApplicationController
  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    if @lead.save
      flash[:notice] = 'Registration successful!'
      redirect_to root_path
      # Handle successful lead creation (e.g., redirect or show a thank you message)
    else
      flash[:notice] = 'Something went wrong try again please'
      render :new
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email)
  end
end
