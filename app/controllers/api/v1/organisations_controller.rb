module Api::V1
  class OrganisationsController < ApiController

    def index
      if params[:types].present?
        organisations = Organisation.where(organisation_type: params[:types])
      else
        organisations = Organisation.all
      end
      organisations = organisations.by_name

      respond_to do |format|
        format.json { render json: organisations_serializer(organisations) }
      end
    end

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

    def organisations_serializer(organisations)
      OrganisationsSerializer.new(organisations)
    end

    def organisation_serializer(organisation)
      OrganisationSerializer.new(organisation)
    end

  end
end
