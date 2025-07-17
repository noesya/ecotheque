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

ActiveRecord::Schema[8.0].define(version: 2025_07_17_105918) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.string "image_alt"
    t.string "image_credit"
    t.boolean "premium", default: false
    t.text "service_access_terms"
    t.string "address"
    t.string "address_additional"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "contact_website"
    t.string "contact_inventory_url"
    t.integer "status", default: 0
    t.text "sources"
  end

  create_table "actors_materials", id: false, force: :cascade do |t|
    t.uuid "actor_id", null: false
    t.uuid "material_id", null: false
    t.index ["material_id", "actor_id"], name: "index_actors_materials_on_material_id_and_actor_id"
  end

  create_table "actors_projects", id: false, force: :cascade do |t|
    t.uuid "actor_id", null: false
    t.uuid "project_id", null: false
    t.index ["actor_id", "project_id"], name: "index_actors_projects_on_actor_id_and_project_id"
    t.index ["project_id", "actor_id"], name: "index_actors_projects_on_project_id_and_actor_id"
  end

  create_table "actors_regions", id: false, force: :cascade do |t|
    t.uuid "actor_id", null: false
    t.uuid "region_id", null: false
    t.index ["actor_id", "region_id"], name: "index_actors_regions_on_actor_id_and_region_id"
    t.index ["region_id", "actor_id"], name: "index_actors_regions_on_region_id_and_actor_id"
  end

  create_table "actors_technics", id: false, force: :cascade do |t|
    t.uuid "actor_id", null: false
    t.uuid "technic_id", null: false
    t.index ["technic_id", "actor_id"], name: "index_actors_technics_on_technic_id_and_actor_id"
  end

  create_table "actors_users", id: false, force: :cascade do |t|
    t.uuid "actor_id", null: false
    t.uuid "user_id", null: false
    t.index ["actor_id", "user_id"], name: "index_actors_users_on_actor_id_and_user_id"
  end

  create_table "admin_file_exports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "uuid", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admin_file_exports_on_user_id"
  end

  create_table "banners", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text"
    t.string "background_color"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "definition_aliases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "definition_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["definition_id"], name: "index_definition_aliases_on_definition_id"
  end

  create_table "definitions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "mailer_contents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "identifier"
    t.string "subject"
    t.text "body"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "actor_id"
    t.boolean "published", default: false
    t.string "image_alt"
    t.string "image_credit"
    t.integer "status", default: 0
    t.text "sources"
    t.index ["actor_id"], name: "index_materials_on_actor_id"
    t.index ["slug"], name: "index_materials_on_slug"
  end

  create_table "materials_projects", id: false, force: :cascade do |t|
    t.uuid "material_id", null: false
    t.uuid "project_id", null: false
    t.index ["material_id", "project_id"], name: "index_materials_projects_on_material_id_and_project_id"
    t.index ["project_id", "material_id"], name: "index_materials_projects_on_project_id_and_material_id"
  end

  create_table "materials_regions", id: false, force: :cascade do |t|
    t.uuid "material_id", null: false
    t.uuid "region_id", null: false
    t.index ["material_id", "region_id"], name: "index_materials_regions_on_material_id_and_region_id"
    t.index ["region_id", "material_id"], name: "index_materials_regions_on_region_id_and_material_id"
  end

  create_table "materials_users", id: false, force: :cascade do |t|
    t.uuid "material_id", null: false
    t.uuid "user_id", null: false
    t.index ["material_id", "user_id"], name: "index_materials_users_on_material_id_and_user_id"
  end

  create_table "page_blocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "page_id", null: false
    t.integer "kind", default: 1
    t.integer "position", default: 1
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "searchable_text_from_data"
    t.index ["page_id"], name: "index_page_blocks_on_page_id"
  end

  create_table "pages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "path", null: false
    t.text "description"
    t.string "internal_identifier"
    t.integer "position"
    t.uuid "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body_class", default: ""
    t.string "slug"
    t.integer "ancestor_kind", default: 0
    t.string "meta_title"
    t.text "meta_description"
    t.string "menu_description"
    t.index ["parent_id"], name: "index_pages_on_parent_id"
  end

  create_table "project_answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "criterion_id", null: false
    t.uuid "project_id", null: false
    t.boolean "value"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterion_id"], name: "index_project_answers_on_criterion_id"
    t.index ["project_id"], name: "index_project_answers_on_project_id"
  end

  create_table "project_criterions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "step"
    t.string "name"
    t.text "hint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1
    t.text "if_you_check"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.string "image_alt"
    t.string "image_credit"
    t.integer "status", default: 0
    t.text "sources"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "projects_regions", id: false, force: :cascade do |t|
    t.uuid "project_id", null: false
    t.uuid "region_id", null: false
    t.index ["project_id", "region_id"], name: "index_projects_regions_on_project_id_and_region_id"
    t.index ["region_id", "project_id"], name: "index_projects_regions_on_region_id_and_project_id"
  end

  create_table "projects_technics", id: false, force: :cascade do |t|
    t.uuid "technic_id", null: false
    t.uuid "project_id", null: false
    t.index ["project_id", "technic_id"], name: "index_projects_technics_on_project_id_and_technic_id"
    t.index ["technic_id", "project_id"], name: "index_projects_technics_on_technic_id_and_project_id"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.uuid "project_id", null: false
    t.uuid "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id"
  end

  create_table "regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_alt"
    t.string "image_credit"
    t.index ["slug"], name: "index_regions_on_slug", unique: true
  end

  create_table "regions_technics", id: false, force: :cascade do |t|
    t.uuid "region_id", null: false
    t.uuid "technic_id", null: false
    t.index ["region_id", "technic_id"], name: "index_regions_technics_on_region_id_and_technic_id"
    t.index ["technic_id", "region_id"], name: "index_regions_technics_on_technic_id_and_region_id"
  end

  create_table "structure_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "kind", default: 0
    t.text "hint"
    t.integer "position", default: 0
    t.string "about_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "zone", default: 3
    t.boolean "with_explanation", default: true
    t.boolean "premium", default: false
    t.boolean "show_in_list", default: false
    t.boolean "show_label", default: true
    t.string "color"
  end

  create_table "structure_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "hint"
    t.integer "position"
    t.uuid "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "in_use", default: false
    t.index ["item_id"], name: "index_structure_options_on_item_id"
  end

  create_table "structure_options_values", id: false, force: :cascade do |t|
    t.uuid "option_id", null: false
    t.uuid "value_id", null: false
    t.index ["option_id"], name: "index_structure_options_values_on_option_id"
    t.index ["value_id"], name: "index_structure_options_values_on_value_id"
  end

  create_table "structure_value_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "value_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "alt"
    t.string "credit"
    t.string "text"
    t.index ["value_id"], name: "index_structure_value_files_on_value_id"
  end

  create_table "structure_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text"
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.uuid "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_type", "about_id"], name: "index_criterion_values_on_about"
    t.index ["item_id"], name: "index_structure_values_on_item_id"
  end

  create_table "technics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.string "image_alt"
    t.string "image_credit"
    t.integer "status", default: 0
    t.text "sources"
  end

  create_table "technics_users", id: false, force: :cascade do |t|
    t.uuid "technic_id", null: false
    t.uuid "user_id", null: false
    t.index ["technic_id", "user_id"], name: "index_technics_users_on_technic_id_and_user_id"
  end

  create_table "transparency_costs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "amount"
    t.uuid "transparency_year_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transparency_year_id"], name: "index_transparency_costs_on_transparency_year_id"
  end

  create_table "transparency_revenues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "amount"
    t.uuid "transparency_year_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transparency_year_id"], name: "index_transparency_revenues_on_transparency_year_id"
  end

  create_table "transparency_years", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.uuid "reply_to_id"
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["about_type", "about_id"], name: "index_user_comments_on_about"
    t.index ["reply_to_id"], name: "index_user_comments_on_reply_to_id"
    t.index ["user_id"], name: "index_user_comments_on_user_id"
  end

  create_table "user_favorites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_type", "about_id"], name: "index_user_favorites_on_about"
    t.index ["user_id"], name: "index_user_favorites_on_user_id"
  end

  create_table "user_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.uuid "blob_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename"
    t.index ["about_type", "about_id"], name: "index_user_logs_on_about"
    t.index ["blob_id"], name: "index_user_logs_on_blob_id"
    t.index ["user_id"], name: "index_user_logs_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0, null: false
    t.string "mobile_phone"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "second_factor_attempts_count", default: 0
    t.string "encrypted_otp_secret_key"
    t.string "encrypted_otp_secret_key_iv"
    t.string "encrypted_otp_secret_key_salt"
    t.string "direct_otp"
    t.datetime "direct_otp_sent_at"
    t.string "direct_otp_delivery_method"
    t.datetime "totp_timestamp", precision: nil
    t.text "description"
    t.string "website"
    t.boolean "allow_listing", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["encrypted_otp_secret_key"], name: "index_users_on_encrypted_otp_secret_key", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_file_exports", "users"
  add_foreign_key "definition_aliases", "definitions"
  add_foreign_key "materials", "actors"
  add_foreign_key "page_blocks", "pages"
  add_foreign_key "pages", "pages", column: "parent_id"
  add_foreign_key "project_answers", "project_criterions", column: "criterion_id"
  add_foreign_key "project_answers", "projects"
  add_foreign_key "structure_options", "structure_items", column: "item_id"
  add_foreign_key "structure_options_values", "structure_options", column: "option_id"
  add_foreign_key "structure_options_values", "structure_values", column: "value_id"
  add_foreign_key "structure_value_files", "structure_values", column: "value_id"
  add_foreign_key "structure_values", "structure_items", column: "item_id"
  add_foreign_key "transparency_costs", "transparency_years"
  add_foreign_key "transparency_revenues", "transparency_years"
  add_foreign_key "user_comments", "user_comments", column: "reply_to_id"
  add_foreign_key "user_comments", "users"
  add_foreign_key "user_favorites", "users"
  add_foreign_key "user_logs", "active_storage_blobs", column: "blob_id"
  add_foreign_key "user_logs", "users"
end
