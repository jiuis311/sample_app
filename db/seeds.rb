User.create!(name: "Linh",
  email: "ltlinh311@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true)

49.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
