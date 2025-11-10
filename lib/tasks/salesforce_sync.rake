namespace :salesforce do
  desc "Sync users to Salesforce that are missing sf_contact_id"
  task sync_unsynced_users: :environment do
    puts "Finding users without Salesforce sync..."
    
    unsynced_users = User.where(sf_contact_id: nil)
                        .where.not(email: nil)
                        .where.not(first_name: nil)
                        .where.not(last_name: nil)
    
    puts "Found #{unsynced_users.count} unsynced users"
    
    if unsynced_users.count == 0
      puts "✅ All users are already synced to Salesforce!"
      next
    end
    
    unsynced_users.each do |user|
      puts "Syncing user: #{user.email} (ID: #{user.id}, created: #{user.created_at})"
      begin
        SalesforceSyncJob.perform_now(user)
        puts "  ✅ Synced successfully!"
      rescue => e
        puts "  ❌ Error: #{e.message}"
      end
    end
    
    puts "\n📊 Sync Summary:"
    puts "Total processed: #{unsynced_users.count}"
    still_unsynced = User.where(sf_contact_id: nil)
                        .where.not(email: nil)
                        .where.not(first_name: nil)
                        .where.not(last_name: nil)
                        .count
    puts "Successfully synced: #{unsynced_users.count - still_unsynced}"
    puts "Failed: #{still_unsynced}"
  end

  desc "Sync users from the last N days (default: 30)"
  task :sync_recent_users, [:days] => :environment do |t, args|
    days = (args[:days] || 30).to_i
    cutoff_date = days.days.ago
    
    puts "Finding users created or updated in the last #{days} days..."
    
    recent_users = User.where("created_at >= ? OR updated_at >= ?", cutoff_date, cutoff_date)
                      .where.not(email: nil)
                      .where.not(first_name: nil)
                      .where.not(last_name: nil)
    
    puts "Found #{recent_users.count} users from the last #{days} days"
    
    if recent_users.count == 0
      puts "No users found in the specified timeframe"
      next
    end
    
    synced = 0
    errors = 0
    
    recent_users.each do |user|
      sync_status = user.sf_contact_id.present? ? "re-syncing" : "new sync"
      puts "#{sync_status.capitalize}: #{user.email} (ID: #{user.id}, created: #{user.created_at})"
      
      begin
        SalesforceSyncJob.perform_now(user)
        synced += 1
        puts "  ✅ Synced successfully! SF ID: #{user.reload.sf_contact_id}"
      rescue => e
        errors += 1
        puts "  ❌ Error: #{e.message}"
      end
    end
    
    puts "\n📊 Sync Summary:"
    puts "Total processed: #{recent_users.count}"
    puts "Successfully synced: #{synced}"
    puts "Errors: #{errors}"
  end

  desc "Sync a specific user by email"
  task :sync_user, [:email] => :environment do |t, args|
    unless args[:email]
      puts "❌ Please provide an email address"
      puts "Usage: rake salesforce:sync_user[user@example.com]"
      next
    end
    
    user = User.find_by(email: args[:email])
    
    unless user
      puts "❌ User not found with email: #{args[:email]}"
      next
    end
    
    puts "Syncing user: #{user.email} (ID: #{user.id})"
    puts "Current SF Contact ID: #{user.sf_contact_id || 'None'}"
    
    begin
      SalesforceSyncJob.perform_now(user)
      user.reload
      puts "✅ Synced successfully!"
      puts "New SF Contact ID: #{user.sf_contact_id}"
    rescue => e
      puts "❌ Error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end

  desc "List all unsynced users"
  task list_unsynced: :environment do
    puts "Users without Salesforce sync:"
    puts "=" * 80
    
    unsynced_users = User.where(sf_contact_id: nil)
                        .where.not(email: nil)
                        .order(created_at: :desc)
    
    if unsynced_users.count == 0
      puts "✅ All users with email addresses are synced!"
      next
    end
    
    unsynced_users.each do |user|
      has_required = user.first_name.present? && user.last_name.present?
      status = has_required ? "Ready to sync" : "Missing required fields"
      
      puts "ID: #{user.id}"
      puts "  Email: #{user.email}"
      puts "  Name: #{user.first_name} #{user.last_name}"
      puts "  Created: #{user.created_at}"
      puts "  Status: #{status}"
      puts "-" * 80
    end
    
    puts "\nTotal unsynced: #{unsynced_users.count}"
  end
end

