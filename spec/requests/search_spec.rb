require 'rails_helper'

RSpec.describe "Search", type: :request do
  before do
    create(:user, gender: 'm', birthdate: 25.years.ago)
    create(:user, gender: 'f', birthdate: 30.years.ago)
    create(:user, religion: 'hindu', birthdate: 35.years.ago)
    create(:user, religion: 'muslim', birthdate: 40.years.ago)
    create(:user, gender: 'm', country: 'US', birthdate: 45.years.ago)
    create(:user, gender: 'm', country: 'IN', birthdate: 50.years.ago)
    create(:user, gender: 'm', country: 'AE', birthdate: 55.years.ago)
  end

  describe "GET /search" do
    it "returns only male users when querying for men" do
      xhr :get, "/search", { gender: 'm' }
      expect(response).to have_http_status(:ok)
      data      = JSON.parse(response.body)
      genders   = data.map { |u| u["gender"]}
      expect(genders).to include('m')
      expect(genders).to_not include('f')
    end

    it "returns only female users when querying for women" do
      xhr :get, "/search", { gender: 'f' }
      expect(response).to have_http_status(:ok)
      data      = JSON.parse(response.body)
      genders   = data.map { |u| u["gender"]}
      expect(genders).to include('f')
      expect(genders).to_not include('m')
    end

    it "returns only countrues queried for" do
      xhr :get, "/search", { countries: ['US', 'IN'], gender: 'm' }
      data        = JSON.parse(response.body)
      countries   = data.map { |u| u["country"]}
      expect(countries).to include('India')
      expect(countries).to include('United States')
      expect(countries).to_not include('United Arab Emirates')
    end
  end
end
