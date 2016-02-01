class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :trackable, polymorphic: true, index: true
      t.datetime :start_at
      t.datetime :end_at
    end
    add_index :trackings, :trackable_type
    add_index(:trackings,
      [:user_id, :trackable_id, :trackable_type, :start_at],
      unique: true, name: 'index_trackings_unique_trackable'
    )
  end
end
