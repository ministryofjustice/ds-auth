module Api::V1
  class OrganisationsController < ApiController

    def index
      respond_to do |format|
        format.json { render json: organisations_serializer(organisations) }
      end
    end

    def show
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

    def organisations
      @organisations ||= find_organisations
    end

    def find_organisations
      scope = Organisation.by_name

      if params[:types].present?
        scope = scope.where(organisation_type: params[:types])
      end

      if params[:uids]
        scope = scope.where(uid: params[:uids])
      end

      scope
    end

    def organisation
      @organisation ||= Organisation.find_by(uid: params[:uid])
    end

    def organisations_serializer(organisations)
      OrganisationsSerializer.new(organisations)
    end

    def organisation_serializer(organisation)
      OrganisationSerializer.new(organisation)
    end
  end
end
