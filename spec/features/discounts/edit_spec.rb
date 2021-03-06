RSpec.describe "discounts show page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Body Care')

    @discount_1 = Discount.create!(percent_discount: 10, quantity: 15, merchant_id: @merchant1.id)
    @discount_2 = Discount.create!(percent_discount: 20, quantity: 30, merchant_id: @merchant1.id)
    @discount_3 = Discount.create!(percent_discount: 30, quantity: 40, merchant_id: @merchant2.id)
  end

  it "shows a user form to create to the bulk discount that is pre-populated" do
    visit merchant_discount_path(@merchant1, @discount_1)

    click_link "Edit Discount"

    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount_1))

    expect(page).to have_field("discount[percent_discount]", :with => "10")
    expect(page).to have_field("discount[quantity]", :with => "15")
  end

  it "allows the user to update the bulk discount when any field is changed" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    fill_in("discount[quantity]", with: 100)

    click_button("Edit Discount")

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))

    expect(page).to have_content("Discount percentage: 10, item quantity: 100")
  end

  it "allows the user to update the bulk discount when all fields are changed" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    fill_in("discount[percent_discount]", with: 30)
    fill_in("discount[quantity]", with: 100)

    click_button("Edit Discount")

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))

    expect(page).to have_content("Discount percentage: 30, item quantity: 100")
  end

  it "won't allow an update with incomplete information" do
    visit edit_merchant_discount_path(@merchant1, @discount_1)

    fill_in("discount[percent_discount]", with: "")
    fill_in("discount[quantity]", with: 100)

    click_button("Edit Discount")

    expect(page).to have_content("Please use only whole numbers in Percent Discount and Quantity fields")
    expect(page).to have_field("discount[quantity]", :with => "100")

    fill_in("discount[percent_discount]", with: "30")

    click_button("Edit Discount")

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))
    expect(page).to have_content("Discount percentage: 30, item quantity: 100")
  end
end

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
