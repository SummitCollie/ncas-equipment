# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when 'development'
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
        identifier: '001',
        requires_scan: true,
        donated_by: 'Musky Husky',
        est_value_cents: 50_000,
      },
      {
        name: 'Nintendo 64',
        identifier: '002',
        donated_by: 'Musky Husky',
        est_value_cents: 2000,
        checked_out: true,
        current_location_id: locations.third.id,
        est_return: 2.days.from_now,
      },
      {
        name: 'Handheld Radio',
        identifier: '003',
      },
    ]
  )

  # Past checkout and checkin
  Checkout.create(
    {
      assets: [assets.first],
      location: locations.first,
      est_return: 1.year.ago,
    }
  )
  Checkin.create(
    {
      assets: [assets.first],
      created_at: 1.year.ago + 1.day,
      updated_at: 1.year.ago + 1.day,
    }
  )

  # Current checkout
  Checkout.create(
    {
      assets: [assets.second],
      location: locations.third,
      est_return: 2.days.from_now,
    }
  )
end
