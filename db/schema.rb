# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_08_14_214644) do
  create_table "agent_interactions", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.integer "user_id", null: false
    t.text "user_message"
    t.text "agent_response"
    t.string "emotional_context"
    t.integer "rating"
    t.text "feedback"
    t.decimal "response_time", precision: 8, scale: 3
    t.string "session_id"
    t.text "context"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_agent_interactions_on_agent_id"
    t.index ["created_at"], name: "index_agent_interactions_on_created_at"
    t.index ["emotional_context"], name: "index_agent_interactions_on_emotional_context"
    t.index ["rating"], name: "index_agent_interactions_on_rating"
    t.index ["session_id"], name: "index_agent_interactions_on_session_id"
    t.index ["user_id"], name: "index_agent_interactions_on_user_id"
  end

  create_table "agent_memories", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.integer "user_id", null: false
    t.string "memory_type", null: false
    t.text "content"
    t.string "emotional_context"
    t.integer "importance_score", default: 5
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_agent_memories_on_agent_id"
    t.index ["created_at"], name: "index_agent_memories_on_created_at"
    t.index ["emotional_context"], name: "index_agent_memories_on_emotional_context"
    t.index ["importance_score"], name: "index_agent_memories_on_importance_score"
    t.index ["memory_type"], name: "index_agent_memories_on_memory_type"
    t.index ["user_id"], name: "index_agent_memories_on_user_id"
  end

  create_table "agents", force: :cascade do |t|
    t.string "name", null: false
    t.string "agent_type", null: false
    t.text "tagline"
    t.text "description"
    t.string "avatar_url"
    t.string "status", default: "active"
    t.text "personality_traits"
    t.text "capabilities"
    t.text "specializations"
    t.text "configuration"
    t.datetime "last_active_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_type"], name: "index_agents_on_agent_type"
    t.index ["name"], name: "index_agents_on_name", unique: true
    t.index ["status"], name: "index_agents_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "agent_interactions", "agents"
  add_foreign_key "agent_interactions", "users"
  add_foreign_key "agent_memories", "agents"
  add_foreign_key "agent_memories", "users"
end
