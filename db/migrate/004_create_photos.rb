class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table(:photos, :options => 'ENGINE=MyISAM') do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :photos
  end
end
