namespace :update do
  task change_empty_to_null: :environment do
    puts 'Update all users'
    User.where("deactivated_at = ''").update_all(deactivated_at: nil)
    User.where("subscription_date = ''").update_all(subscription_date: nil)
    User.where("subscription_end_date = ''").update_all(subscription_end_date: nil)
  end
end
