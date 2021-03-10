require 'rails_helper'

RSpec.describe 'SwaggerService API' do
  before :each do
    json_response = File.read('spec/fixtures/holidays.json')
    stub_request(:get,'https://date.nager.at/Api/v2/NextPublicHolidays/US').to_return(status: 200, body: json_response)
  end 

  it "returns a string object" do
    test = SwaggerService.holidays

    expect(test.class).to eq(String)
  end
end
