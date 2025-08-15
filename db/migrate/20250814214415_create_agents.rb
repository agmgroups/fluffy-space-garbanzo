class CreateAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :agents do |t|
      t.string :name, null: false
      t.string :agent_type, null: false
      t.text :tagline
      t.text :description
      t.string :avatar_url
      t.string :status, default: 'active'
      t.text :personality_traits
      t.text :capabilities
      t.text :specializations
      t.text :configuration
      t.datetime :last_active_at

      t.timestamps
    end
    
    add_index :agents, :agent_type
    add_index :agents, :status
    add_index :agents, :name, unique: true
  end
end
