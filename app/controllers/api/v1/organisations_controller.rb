module Api::V1
  class OrganisationsController < ApiController

    def show
      organisation = Organisation.find_by(uid: params[:uid])
      if organisation.present?
        respond_to do |format|
          format.json { render json: organisation_serializer(organisation) }
        end
      else
        respond_to do |format|
          format.json { render json: { "errors" => ["Resource not found"] }, status: 404 }
        end
      end
    end

    private

    def organisation_serializer(organisation)
      OrganisationSerializer.new(
        organisation: organisation
      )
    end

  end
end
