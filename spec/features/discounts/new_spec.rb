require 'rails_helper'

RSpec.describe "create new discounts" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Body Care')

    json_response = File.read('spec/fixtures/holidays.json')
    stub_request(:get,'https://date.nager.at/Api/v2/NextPublicHolidays/US').to_return(status: 200, body: json_response)
  end

  it "shows a user form to create a new bulk discount and creates it" do
    visit new_merchant_discount_path(@merchant1)

    expect(page).to have_content("Create a Discount")

    fill_in("percent_discount", with: 0.1)
    fill_in("quantity", with: 20)

    click_button("Create Discount")

    expect(page).to have_current_path(merchant_discounts_path(@merchant1))
    expect(page).to have_content("#{@merchant1.discounts.first.percent_discount} percent off when #{@merchant1.discounts.first.quantity} items are bought.")
  end

  it "will not let invalid data be passed into the create form" do
    visit new_merchant_discount_path(@merchant1)

    fill_in("percent_discount", with: "ten")
    fill_in("quantity", with: 10)

    click_button("Create Discount")

    expect(page).to have_content("Percent discount is not a number")

    fill_in("percent_discount", with: 0.1)
    fill_in("quantity", with: 20)

    click_button("Create Discount")

    expect(page).to have_current_path(merchant_discounts_path(@merchant1))

    expect(page).to have_content("#{@merchant1.discounts.first.percent_discount} percent off when #{@merchant1.discounts.first.quantity} items are bought.")
  end

  it "will not let an incomplete form be accepted" do
    visit new_merchant_discount_path(@merchant1)

    fill_in("percent_discount", with: "ten")

    click_button("Create Discount")

    expect(page).to have_content("Quantity can't be blank")
    expect(page).to have_content("Quantity is not a number")
    expect(page).to have_content("Percent discount is not a number")

    fill_in("percent_discount", with: 0.1)
    fill_in("quantity", with: 20)

    click_button("Create Discount")

    expect(page).to have_current_path(merchant_discounts_path(@merchant1))

    expect(page).to have_content("#{@merchant1.discounts.first.percent_discount} percent off when #{@merchant1.discounts.first.quantity} items are bought.")
  end
end
