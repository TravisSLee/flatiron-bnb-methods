class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  def city_openings(start_date, end_date)
    availble_listings = []
    cities = City.all
    cities.each do |c|
      c.listings.each do |l|
          l.reservations.each do |r|
            if (r.checkin >= start_date.to_date) && (r.checkout <= end_date.to_date )
              availble_listings << l
            end
          end
      end
    end
    availble_listings
  end

  def self.highest_ratio_res_to_listings
    
    cities = self.all
    highest_city_ratio = 0
    highest_city_id = 0

    cities.each do |c|
      listing_count = c.listings.count
      reservation_count = 0
      c.listings.each do |listing|
        reservation_count += listing.reservations.count
      end

      ratio = reservation_count.to_f / listing_count.to_f

      if ratio > highest_city_ratio
        highest_city_id = c.id
        highest_city_ratio = ratio
      end
    end
    self.find(highest_city_id)
  end

  def self.most_res
    cities = self.all
    highest_city_reservation = 0
    highest_city_id = 0

    cities.each do |c|
      listing_count = c.listings.count
      reservation_count = 0
      c.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      if reservation_count > highest_city_reservation
        highest_city_id = c.id
        highest_city_reservation = reservation_count
      end
    end
    self.find(highest_city_id)
  end
end