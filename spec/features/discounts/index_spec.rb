require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Body Care')

    @discount_1 = Discount.create!(percent_discount: 10, quantity: 15, merchant_id: @merchant1.id)
    @discount_2 = Discount.create!(percent_discount: 15, quantity: 30, merchant_id: @merchant1.id)
    @discount_3 = Discount.create!(percent_discount: 30, quantity: 40, merchant_id: @merchant2.id)
  end

  it "can show all discounts with percent and quantity on the discounts index page" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_content("#{@discount_1.percent_discount} percent off when #{@discount_1.quantity} items are bought.")
    expect(page).to have_content("#{@discount_2.percent_discount} percent off when #{@discount_2.quantity} items are bought.")
    expect(page).to have_no_content("#{@discount_3.percent_discount} percent off when #{@discount_3.quantity} items are bought.")
  end

  it "shows a link for each bulk discount displayed" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link("Discount", :href=>"/merchant/#{@merchant1.id}/discounts/#{@discount_1.id}")
    expect(page).to have_link("Discount", :href=>"/merchant/#{@merchant1.id}/discounts/#{@discount_2.id}")
  end
end 