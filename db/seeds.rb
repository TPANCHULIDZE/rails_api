require 'faker'

Product.delete_all
User.delete_all
3.times do
  user = User.create!(username: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password)

  2.times do
    product = Product.create!(
    title: Faker::Commerce.product_name,
    price: rand(1.0..100.0),
    published: true,
    user_id: user.id
    )
  end
end