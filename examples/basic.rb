require 'dry-validation'

schema = Dry::Schema.build do
  required(:email).filled

  required(:age).filled(:int?, gt?: 18)
end

errors = schema.call(email: 'jane@doe.org', age: 19).messages

puts errors.inspect

errors = schema.call(email: nil, age: 19).messages

puts errors.inspect
