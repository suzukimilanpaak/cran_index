require 'machinist/active_record'

Package.blueprint do
  name { "Package_#{sn}" }
  current_version { sn }
end

Description.blueprint do
  version { sn }
  title { "Description_#{sn}" }
  description { "description #{sn}" }
  published_at { 1.day.ago }
end
