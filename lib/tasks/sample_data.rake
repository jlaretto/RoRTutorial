namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    create_Users
    create_Posts
    create_Followers
    
  end
end

def create_Users  
  User.create!(name: "Jeff Laretto",
               email: "jeff@laretto.net",
               password: "foobar",
               password_confirmation: "foobar")
  @user = User.create!(name: "Jeff Laretto (Admin)",
                            email: "admin@laretto.net",
                            password: "foobar",
                            password_confirmation: "foobar")
  @user.toggle!(:admin)                 
  User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar")
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def create_Posts
  users = User.all(limit: 6)
      50.times do
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content) }
      end
end

def create_Followers
  user = User.first
  User.all[2..50].each {|u| user.follow!(u)}
  User.all[3..40].each {|u| u.follow!(user)}
end