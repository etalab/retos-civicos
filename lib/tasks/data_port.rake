require 'open-uri'

task data_port: ['orgs:create_orgs_and_link_to_challenges', 
                 'users:create_members_and_migrate_users',
                 'users:import_twitter_avatars']

desc "Create members for existing users and port their collaborations for Challenges"
namespace :users do

  task create_members_and_migrate_users: :environment do
    # Create members
    puts "Creating members..."
    User.where(userable_type: nil).each do |user|
      user.create_role 
    end

    # Relate collaborations to members
    puts "Relating collaborations to members..."
    Collaboration.all.each do |c|
      if c.user.member?
        c.member = c.user.userable 
        c.save
      end
    end

    puts "Cleaning up members with user equals nil..."
    Member.all.each { |m| m.destroy if m.user.nil? }
  end

end

desc "Create Organizations and Port challenges ownership to Organizations"
namespace :orgs do

  task create_orgs_and_link_to_challenges: :environment do
    creators = Challenge.pluck(:creator_id)
    users = User.find creators

    puts "Creating organizations..."
    users.each do |user|
      user.create_role({ organization: true })
    end

    puts "Mapping organization challenges..."
    users.each do |user|
      organization = Organization.find user.userable_id
      challenges = Challenge.where(creator_id: user.id)
      challenges.each do |c| 
        c.organization = organization
        c.save
      end
    end
  end
end

desc 'Imports the twitter avatar url to the users model'
namespace :users do
  task import_twitter_avatars: :environment do
    
   puts 'Fetching users...'
   User.from_twitter.readonly(false).each do |user|
     num_attempts = 0
     begin
       num_attempts += 1
       twitter_auth = user.authentications.where(provider: 'twitter').first
       image_url = Twitter.user(twitter_auth.uid.to_i).profile_image_url.sub("_normal", "") 
       output_file = File.open("#{Rails.root}/tmp/#{user.id}.jpeg", "wb")
       open(image_url) do |f|
         output_file.puts f.read
       end

       user.avatar = output_file
       user.save validate: false
       File.delete(output_file)
     rescue
       if num_attempts % 3 == 0
         sleep(15*60) # minutes * 60 seconds
         retry
       else
         retry
       end
     end
   end 
  end
end
