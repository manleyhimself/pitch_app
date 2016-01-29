# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  first_name   :string
#  last_name    :string
#  full_name    :string
#  gender       :string
#  password     :string
#  university   :string
#  job_title    :string
#  company_name :string
#  blurb        :string
#  birthday     :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do

  factory :user do
    first_name "MyString"
    last_name "MyString"
    full_name "MyString"
    gender "MyString"
    password "MyString"
    university "MyString"
    job_title "MyString"
    company_name "MyString"
    blurb "MyString"
    birthday "2016-01-26"
  end

end
