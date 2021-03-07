require 'rails_helper'

RSpec.describe "discounts index page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Body Care')

    @discount_1 = Discount.create!(percent_discount: 10, quantity: 15, merchant_id: @merchant1.id)
    @discount_2 = Discount.create!(percent_discount: 20, quantity: 30, merchant_id: @merchant1.id)
    @discount_3 = Discount.create!(percent_discount: 30, quantity: 40, merchant_id: @merchant2.id)
  end

  it "shows an individual discount on the show page" do
    json_response = File.read('spec/fixtures/holidays.json')
    stub_request(:get,'https://date.nager.at/Api/v2/NextPublicHolidays/US').to_return(status: 200, body: json_response)
    visit merchant_discounts_path(@merchant1)

    click_link "Discount", :href=>"/merchant/#{@merchant1.id}/discounts/#{@discount_1.id}"

    expect(page).to have_current_path(merchant_discount_path(@merchant1, @discount_1))

    expect(page).to have_content("Discount percentage: #{@discount_1.percent_discount}, item quantity: #{@discount_1.quantity}")
    expect(page).to have_no_content("20")
    expect(page).to have_no_content("30")
  end

  it "shows a link to edit the bulk discount" do
    visit merchant_discount_path(@merchant1, @discount_1)

    expect(page).to have_link("Edit Discount")
  end
end
