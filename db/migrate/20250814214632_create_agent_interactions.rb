class CreateAgentInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :agent_interactions do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :user_message
      t.text :agent_response
      t.string :emotional_context
      t.integer :rating
      t.text :feedback
      t.decimal :response_time, precision: 8, scale: 3
      t.string :session_id
      t.text :context
      t.text :metadata

      t.timestamps
    end
    
    add_index :agent_interactions, :session_id
    add_index :agent_interactions, :emotional_context
    add_index :agent_interactions, :rating
    add_index :agent_interactions, :created_at
  end
end
