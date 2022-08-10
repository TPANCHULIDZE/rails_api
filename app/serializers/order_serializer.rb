class OrderSerializer
  include JSONAPI::Serializer
  attributes :total

  has_many :products
  belongs_to :user

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
