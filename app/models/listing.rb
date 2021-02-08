class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  # after_create :make_host
  # after_destroy :no_host

  def average_review_rating
    listing = Listing.find(id)
    review_count = 0
    review_rating_total = 0

    
      listing.reservations.each do |res|
        if res.review
        review_count += 1
        review_rating_total += res.review.rating
        end
      end
    average_rating = review_rating_total.to_f / review_count.to_f
    average_rating 
  end

  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
        where.not(reservations: {checkin: start_date..end_date}) &
      joins(:reservations).
        where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end

  

  def unset_host_as_host
    # remove .id
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(is_host: false)
    end
  end

  def set_host_as_host
    unless host.is_host?
      host.update(is_host: true)
    end
  end
  
end
