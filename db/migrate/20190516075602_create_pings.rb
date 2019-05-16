class CreatePings < ActiveRecord::Migration[5.2]
  enable_extension 'hstore' unless extension_enabled?('hstore')

  def change
    create_table :pings do |t|
      t.string :url
      t.hstore :validation_errors
      t.hstore :parameters

      t.timestamps
    end
  end
end