# app/controllers/api/v1/leads_controller.rb
module Api
  module V1
    class LeadsController < ApplicationController
      before_action :set_lead, only: [:show, :update, :destroy]

      # GET /api/v1/leads
      def index
        @leads = Lead.all
        render json: @leads
      end

      # GET /api/v1/leads/:id
      def show
        render json: @lead
      end

      # POST /api/v1/leads
      def create
        @lead = Lead.new(lead_params)

        if @lead.save
          render json: @lead, status: :created
        else
          render json: { errors: @lead.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/leads/:id
      def update
        if @lead.update(lead_params)
          render json: @lead
        else
          render json: { errors: @lead.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/leads/:id
      def destroy
        @lead.destroy
        head :no_content
      end

      private

      def set_lead
        @lead = Lead.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Lead not found' }, status: :not_found
      end

      def lead_params
        params.require(:lead).permit(:name, :email, :phone, :message, :status)
      end
    end
  end
end