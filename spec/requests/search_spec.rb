require 'rails_helper'

RSpec.describe "Search", type: :request do
  before do
    create(:member, gender: 'm', birthdate: 25.years.ago)
    create(:member, gender: 'f', birthdate: 30.years.ago)
    create(:member, religion: 'hindu', gender: 'm', birthdate: 35.years.ago)
    create(:member, religion: 'muslim', gender: 'm', birthdate: 40.years.ago)
    create(:member, gender: 'm', country: 'US', birthdate: 45.years.ago)
    create(:member, gender: 'm', country: 'IN', birthdate: 50.years.ago)
    create(:member, gender: 'm', country: 'AE', birthdate: 55.years.ago)

    create(:inactive_user, gender: 'm')
  end

  describe "GET /search" do
    context "gender search" do
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
    end

    context "active user search" do
      it "does not return inactive users" do
        xhr :get, "/search", { gender: 'm' }
        expect(response).to have_http_status(:ok)
        data      = JSON.parse(response.body)
        expect(data.count).to eq(6)
      end
    end

    context "country filter" do
      it "returns only countries queried for" do
        xhr :get, "/search", { countries: ['US', 'IN'], gender: 'm' }
        data        = JSON.parse(response.body)
        countries   = data.map { |u| u["country"]}
        expect(countries).to include('India')
        expect(countries).to include('United States')
        expect(countries).to_not include('United Arab Emirates')
      end
    end

    context "religion filter" do
      it "returns only religion queried for" do
        xhr :get, "/search", { religion: 'hindu', gender: 'm' }
        data        = JSON.parse(response.body)
        religions   = data.map { |u| u["religion"]}
        expect(religions).to include('Hindu')
        expect(religions).to_not include('Muslim')
      end
    end

    context "status filter" do
      it "returns only status queried for" do
        unmarried_user = create(:member, status: 'unmarried', gender: 'm')
        divorced_user  = create(:member, status: 'divorced', gender: 'm')
        xhr :get, "/search", { status: 'divorced', gender: 'm' }
        data  = JSON.parse(response.body)
        ids   = data.map { |u| u["id"]}
        expect(ids).to include(divorced_user.id)
        expect(ids).to_not include(unmarried_user.id)
      end
    end

    context "caste filter" do
      it "returns only castes queries for" do
        br1 = create(:brahmin, gender: 'm', sect: 'brh')
        br2 = create(:brahmin, gender: 'm', sect: 'brm')
        br3 = create(:brahmin, gender: 'm', sect: 'bri')
        xhr :get, "/search", { gender: 'm', sects:['brh', 'brm'], religion: 'hindu' }
        data  = JSON.parse(response.body)
        ids   = data.map { |u| u["id"]}
        expect(ids).to include(br1.id)
        expect(ids).to include(br2.id)
        expect(ids).to_not include(br3.id)
      end
    end
  end
end
