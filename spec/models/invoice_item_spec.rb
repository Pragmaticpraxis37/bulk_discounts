require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:discounts).through(:merchant) }
  end

  it "#discount_applied_status" do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = Discount.create!(percent_discount: 0.20, quantity: 5, merchant_id: @merchant1.id)
    @discount2 = Discount.create!(percent_discount: 0.15, quantity: 6, merchant_id: @merchant1.id)
    @discount7 = Discount.create!(percent_discount: 0.50, quantity: 50, merchant_id: @merchant1.id)
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @item_9 = Item.create!(name: "Butterfly", description: "It flies", unit_price: 15, merchant_id: @merchant1.id)
    @item_10 = Item.create!(name: "A fly", description: "It flies", unit_price: 15, merchant_id: @merchant1.id)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 10, unit_price: 5, status: 1)
    @ii_12 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_9.id, quantity: 2, unit_price: 5, status: 1)
    @ii_13 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_9.id, quantity: 50, unit_price: 5, status: 1)

    expect(@ii_1.discount_applied_status).to eq(@discount1.id)
    expect(@ii_11.discount_applied_status).to eq(@discount1.id)
    expect(@ii_12.discount_applied_status).to eq(nil)
    expect(@ii_13.discount_applied_status).to eq(@discount7.id)
  end
end
