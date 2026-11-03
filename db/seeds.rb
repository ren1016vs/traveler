3.times do |n|
  User.create(name: "サンプル#{n}", email: "sample#{n}@example.com", password: "password")
end