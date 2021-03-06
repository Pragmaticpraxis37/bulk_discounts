require 'rails_helper'

RSpec.describe 'SwaggerService API' do
  it "returns a string object" do
    test = SwaggerService.holidays

    expect(test.class).to eq(String)
  end
end
