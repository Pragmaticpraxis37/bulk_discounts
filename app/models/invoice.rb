class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_with_discounts
    discounts_total = 0

    items.joins(merchant: :discounts)
    .select("invoice_items.item_id, MAX(invoice_items.quantity * invoice_items.unit_price * discounts.percent_discount)")
    .where("invoice_items.quantity >= discounts.quantity")
    .group("invoice_items.item_id").each do |row|
      discounts_total += row.max
    end

    discounts_total
  end

  def calculate_total_revenue_with_discounts
    total_revenue - total_revenue_with_discounts
  end
end


# items.joins(merchant: :discounts).select("invoice_items.item_id, MAX(invoice_items.quantity * invoice_items.unit_price * discounts.percent_discount)").where("invoice_items.quantity >= discounts.quantity").group("invoice_items.item_id")
