RSpec.describe "discounts show page" do
  describe "as a user when I go to the discounts show page" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Body Care')

      @discount_1 = Discount.create!(percent_discount: 0.10, quantity: 15, merchant_id: @merchant1.id)
      @discount_2 = Discount.create!(percent_discount: 0.20, quantity: 30, merchant_id: @merchant1.id)
      @discount_3 = Discount.create!(percent_discount: 0.30, quantity: 40, merchant_id: @merchant2.id)
    end

    it "shows a user form to create to the bulk discount that is pre-populated" do
      visit merchant_discount_path(@merchant1, @discount_1)

      click_link "Edit Discount"

      expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount_1))
      expect(page).to have_field("percent_discount", :with => "0.1")
      expect(page).to have_field("quantity", :with => "15")
    end

    it "allows the user to update the bulk discount when any field is changed" do
      visit edit_merchant_discount_path(@merchant1, @discount_1)

      fill_in("quantity", with: 99)

      click_button("Edit Discount")

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))

      expect(page).to have_content("Discount percentage: 0.1, item quantity: 99")
    end

    it "allows the user to update the bulk discount when all fields are changed" do
      visit edit_merchant_discount_path(@merchant1, @discount_1)

      fill_in("percent_discount", with: 0.2)
      fill_in("quantity", with: 100)

      click_button("Edit Discount")

      @discount_1.reload

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))

      expect(page).to have_content("Discount percentage: #{@discount_1.percent_discount}, item quantity: #{@discount_1.quantity}")
    end

    it "won't allow an update with incomplete information" do
      visit edit_merchant_discount_path(@merchant1, @discount_1)

      fill_in("percent_discount", with: "")
      fill_in("quantity", with: 100)

      click_button("Edit Discount")

      expect(page).to have_content("Percent discount is not a number")
      expect(page).to have_content("Percent discount can't be blank")

      fill_in("percent_discount", with: 0.3)

      click_button("Edit Discount")

      @discount_1.reload

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount_1))

      expect(page).to have_content("Discount percentage: #{@discount_1.percent_discount}, item quantity: #{@discount_1.quantity}")
    end
  end
end
