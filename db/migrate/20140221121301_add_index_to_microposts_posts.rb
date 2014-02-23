class AddIndexToMicropostsPosts < ActiveRecord::Migration
  def change
  	add_column :microposts, :post_id, :integer
  	add_index :microposts, [:post_id]
  end
end
