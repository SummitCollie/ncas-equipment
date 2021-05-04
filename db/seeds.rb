# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when 'production'
  default_admin = Rails.application.credentials.prod_default_admin
  if default_admin
    User.create({
      email: default_admin,
      display_name: 'Site Admin',
      password: Devise.friendly_token,
      admin: true,
    })
  end

when 'development'
  User.create!(
    [
      {
        email: 'dog@example.com',
        display_name: 'Dog',
        password: '123456',
        admin: true,
      },
      {
        email: 'cat@example.com',
        display_name: 'Cat',
        password: '123456',
      },
      {
        email: 'JavaDog.Dev@gmail.com',
        telegram: '@SummitBC',
        display_name: 'Summit',
        password: '123456',
        admin: true,
      },
    ]
  )
  Event.create!([{ name: 'FWA 2019' }, { name: 'FWA 2020', active: true }])
  Location.create!(
    [
      { name: 'Game Room', event: Event.first, for_checkout: true },
      { name: 'Con Ops', event: Event.first, for_checkout: true },

      { name: 'Game Room', event: Event.second, for_checkout: true },
      { name: 'Con Ops', event: Event.second, for_checkout: true },
      { name: 'Main Events Hall', event: Event.second, for_checkout: true },

      { name: 'Storeroom', event: Event.first, for_checkin: true },
      { name: 'Storeroom', event: Event.second, for_checkin: true },
    ]
  )

  Asset.create!(
    [
      {
        name: 'Sony 55" TV',
        barcode: '001',
        checkout_scan_required: true,
        donated_by: 'Musky Husky',
        est_value_cents: 50_000,
        tag_list: 'electronics, tvs, gaming',
      },
      {
        name: 'Nintendo 64',
        barcode: '002',
        donated_by: 'Musky Husky',
        est_value_cents: 2000,
        tag_list: 'electronics, game consoles',
      },
      {
        name: 'Handheld Radio',
        barcode: '003',
        tag_list: 'electronics, communication, radios',
      },
      {
        name: 'Loaner Fursuit',
        description: "it's all wet...",
        location: Location.offset(6).limit(1).first,
        user: nil,
        est_value_cents: 25,
        tag_list: 'fursuits, cold, wet, sad',
      },
      {
        name: 'Mixing Board',
        location: Location.fifth,
        user: User.second,
        tag_list: 'A/V Equipment, audio, electronics',
      },
      {
        name: 'Stage Microphone',
        description: 'Model #42069',
        location: Location.fifth,
        user: User.third,
        tag_list: 'A/V Equipment, audio, electronics',
      },
    ]
  )

  # Past Checkout and checkin
  Checkout.create!({
    user: User.first,
    assets: [Asset.first, Asset.second],
    location: Location.first,
    est_return: 1.year.ago + 3.days,
    created_at: 1.year.ago,
    updated_at: 1.year.ago,
  })
  Checkin.create!({
    user: User.first,
    assets: [Asset.first, Asset.second],
    location: Location.offset(5).limit(1).first,
    returned_at: 1.year.ago + 2.days + 30.minutes,
  })

  # Recent Checkout
  Checkout.create!({
    user: User.second,
    assets: [Asset.third],
    location: Location.fourth,
    est_return: 2.days.from_now,
    created_at: 1.day.ago,
    updated_at: 1.day.ago,
  })
end
