class CreateWorkoutsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string    :workout
      t.string    :comment
      t.integer   :duration
      t.float     :mileage
      t.datetime  :date
      t.integer   :user_id
    end
  end
end
