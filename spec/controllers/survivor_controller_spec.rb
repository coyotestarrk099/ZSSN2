require 'rails_helper'

#https://relishapp.com/rspec/rspec-rails/v/3-8/docs/request-specs/request-spec

RSpec.describe SurvivorsController, type: :controller do
	describe "Post Survivor" do
	    it "survivors" do
	      post :create, params: { survivor: { name: "My Widget"} }
	      expect(response).to have_http_status(:created)
	    end
	 end
end
