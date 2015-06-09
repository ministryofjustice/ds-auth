require "rails_helper"

RSpec.describe StatusController, type: :controller do

  describe "GET index" do
    it "returns 200 status code" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context "HTML request" do
      it "returns OK in body" do
        get :index
        expect(response.body).to include("OK")
      end
    end

    context "JSON request" do
      it "returns a JSON status :ok" do
        get :index, format: "json"
        expect(JSON.parse response.body.strip).to eq({"status" => "OK"})
      end
    end

    context "XML request" do
      it "returns a XML status :ok" do
        get :index, format: "xml"
        expect(response.body.strip).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Status>OK</Status>\n</Response>")
      end
    end

    context "other MIME type" do
      it "returns OK in body" do
        get :index, format: "text"
        expect(response.body).to include("OK")
      end
    end
  end

  describe "GET /ping" do
    context "with a failing request" do
      it "returns 500 status codes for situations where an error occurs" do
        expect_any_instance_of(PingResponse).to receive(:ok?).and_return(false)

        get :ping
        expect(response).to have_http_status(:error)
      end
    end

    context "with a valid config setup" do
      let(:fake_response) { { irrelevant_data: "irrelevant_response" }.with_indifferent_access }

      before :each do
        allow_any_instance_of(PingResponse).to receive(:ok?).and_return(true)
        allow_any_instance_of(PingResponse).to receive(:data).and_return(fake_response)
      end

      it "returns an :ok status code for json requests" do
        get :ping, format: "json"
        expect(response).to have_http_status(:ok)
      end

      it "returns the expected JSON result" do
        get :ping, format: "json"
        expect(JSON.parse response.body.strip).to eq(fake_response)
      end

      it "returns an :ok status code for non-json requests" do
        get :ping, format: "html"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
