class ChangeMicropostAndPostToText < ActiveRecord::Migration
  def change
  	change_column :microposts, :content, :text, :limit => nil
  	change_column :posts, :content, :text, :limit => nil
  end
end
