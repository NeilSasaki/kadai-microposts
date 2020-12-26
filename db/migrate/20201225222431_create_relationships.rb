class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      
      t.index [:user_id, :follow_id], unique: true #user_id とfollow_idの重複は許されない
    end
  end
end
