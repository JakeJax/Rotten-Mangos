class ChangeImageColumnName < ActiveRecord::Migration
  def change
    rename_column :movies, :poster_image_url, :image
  end
end
