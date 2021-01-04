# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when 'development'
  users = User.create(
    [
      { email: 'dog@example.com', password: '123456' },
      { email: 'cat@example.com', password: '123456' },
    ]
  )
  events = Event.create([{ name: 'FWA 2019' }, { name: 'FWA 2020', active: true }])
  locations = Location.create(
    [
      { name: 'Game Room', event: events.first },
      { name: 'Con Ops', event: events.first },

      { name: 'Game Room', event: events.second },
      { name: 'Con Ops', event: events.second },
      { name: 'Main Events Hall', event: events.second },
    ]
  )

  assets = Asset.create(
    [
      {
        name: 'Sony 55" TV',
        barcode: '001',
        checkout_scan_required: true,
        donated_by: 'Musky Husky',
        est_value_cents: 50_000,
      },
      {
        name: 'Nintendo 64',
        barcode: '002',
        donated_by: 'Musky Husky',
        est_value_cents: 2000,
      },
      {
        name: 'Handheld Radio',
        barcode: '003',
      },
    ]
  )

  # Past checkout
  past_order = Order.create(
    { user: users.first, created_at: 1.year.ago, updated_at: 1.year.ago }
  )
  Checkout.create(
    {
      asset: assets.first,
      user: users.first,
      order: past_order,
      location: locations.first,
      est_return: 1.year.ago + 3.days,
      returned_at: 1.year.ago + 2.days + 30.minutes,
    }
  )

  # Current checkout
  current_order = Order.create({ user: users.second })
  Checkout.create(
    {
      asset: assets.second,
      user: users.second,
      order: current_order,
      location: locations.third,
      est_return: 2.days.from_now,
    }
  )
end
