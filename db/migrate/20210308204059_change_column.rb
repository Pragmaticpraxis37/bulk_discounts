class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :discounts, :percent_discount, :float
  end
end
