require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end

  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "#calculate_total_revenue_with_discounts" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @discount1 = Discount.create!(percent_discount: 0.1, quantity: 10, merchant_id: @merchant1.id)
      @discount2 = Discount.create!(percent_discount: 0.05, quantity: 6, merchant_id: @merchant1.id)
      @discount7 = Discount.create!(percent_discount: 0.50, quantity: 50, merchant_id: @merchant1.id)
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 10, unit_price: 5, status: 1)

      @merchant2 = Merchant.create!(name: 'Hair Care II')
      @disconunt3 = Discount.create!(percent_discount: 0.05, quantity: 11, merchant_id: @merchant2.id)
      @item_100 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant2.id, status: 1)
      @item_101 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant2.id)
      @customer_100 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_2 = Invoice.create!(customer_id: @customer_100.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_100 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_100.id, quantity: 5, unit_price: 10, status: 2)
      @ii_101 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_101.id, quantity: 10, unit_price: 5, status: 1)

      @merchant3 = Merchant.create!(name: 'Hair Care III')
      @disconunt4 = Discount.create!(percent_discount: 0.05, quantity: 11, merchant_id: @merchant3.id)
      @disconunt5 = Discount.create!(percent_discount: 0.10, quantity: 11, merchant_id: @merchant3.id)
      @item_200 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant3.id, status: 1)
      @item_201 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant3.id)
      @customer_200 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_3 = Invoice.create!(customer_id: @customer_200.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_200 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_200.id, quantity: 5, unit_price: 10, status: 2)
      @ii_201 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_201.id, quantity: 15, unit_price: 5, status: 1)

      @merchant4 = Merchant.create!(name: 'Hair Care IV')
      @disconunt10 = Discount.create!(percent_discount: 0.05, quantity: 11, merchant_id: @merchant4.id)
      @disconunt11 = Discount.create!(percent_discount: 0.10, quantity: 11, merchant_id: @merchant4.id)
      @item_300 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant4.id, status: 1)
      @item_301 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant4.id)
      @customer_300 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_4 = Invoice.create!(customer_id: @customer_300.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_300 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_300.id, quantity: 5, unit_price: 10, status: 2)
      @ii_301 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_301.id, quantity: 15, unit_price: 5, status: 1)

      @merchant5 = Merchant.create!(name: 'Hair Care V')
      @item_400 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant5.id, status: 1)
      @item_401 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant5.id)
      @customer_400 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_4 = Invoice.create!(customer_id: @customer_400.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_400 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_400.id, quantity: 5, unit_price: 10, status: 2)
      @ii_401 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_401.id, quantity: 15, unit_price: 5, status: 1)

      expect(@invoice_1.calculate_total_revenue_with_discounts).to eq(95)
      expect(@invoice_2.calculate_total_revenue_with_discounts).to eq(100)
      expect(@invoice_3.calculate_total_revenue_with_discounts).to eq(117.5)
      # expect(@invoice_4.calculate_total_revenue_with_discounts).to eq(117.5)
    end
  end
end
