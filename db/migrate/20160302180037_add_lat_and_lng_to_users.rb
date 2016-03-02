class AddLatAndLngToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lat, :float     
    add_column :users, :lng, :float
    # After some reading float seemed like the accepted value for lat/lng 
    # Other options are 'point' which stores both lat/long as x/y in one row or 
    # decimal(9,6) which is xxx.xxxxxx -- idk if you have a preference or any experience with it. 
    add_column :users, :interested_in, :integer, index: true
    change_column :users, :gender, :integer, index: true
  end
end
