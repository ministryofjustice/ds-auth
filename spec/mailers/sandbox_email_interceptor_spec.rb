require "rails_helper"

RSpec.describe SandboxEmailInterceptor do
  describe ".delivering_email" do
    it "assigns the email address from Settings" do
      msg = double("message")

      expect(msg).to receive(:to=).with(["iamadefencesolicitor@gmail.com"])

      SandboxEmailInterceptor.delivering_email(msg)
    end
  end
end
