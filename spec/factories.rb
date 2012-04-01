FactoryGirl.define do
  factory :user do
    name     "Jeff Laretto"
    email    "jeff@laretto.net"
    password "foobar"
    password_confirmation "foobar"
  end
end