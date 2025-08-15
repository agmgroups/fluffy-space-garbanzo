class CreateAgentMemories < ActiveRecord::Migration[7.1]
  def change
    create_table :agent_memories do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :memory_type, null: false
      t.text :content
      t.string :emotional_context
      t.integer :importance_score, default: 5
      t.text :tags

      t.timestamps
    end
    
    add_index :agent_memories, :memory_type
    add_index :agent_memories, :emotional_context
    add_index :agent_memories, :importance_score
    add_index :agent_memories, :created_at
  end
end
