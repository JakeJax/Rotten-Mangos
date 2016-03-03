require 'pry'
class Movie < ActiveRecord::Base
  
  has_many :reviews

  validates :title,
  presence: true

  validates :director,
  presence: true

  validates :runtime_in_minutes,
  numericality: { only_integer: true }

  validates :description,
  presence: true

  # validates :poster_image_url,
  # presence: true
  
  validate :release_date_is_in_the_past

  validates :release_date,
  presence: true

  mount_uploader :image, ImageUploader

  validates_processing_of :image

  validate :image_size_validation

  RUNTIME_QUERIES = ["runtime_in_minutes <= 90",
                     "runtime_in_minutes > 90 and runtime_in_minutes <= 120",
                     "runtime_in_minutes > 120"]

  class << self

    def query_for(query)
      search_type, term = query
      # binding.pry
      case search_type
      when :title
        ["title LIKE ?", "%#{term}%"]
      when :director
        ["director LIKE ?", "%#{term}%"]
      when :runtime
        RUNTIME_QUERIES[term.to_i]
      end
    end

    def search(queries)
      results = Movie.all
      queries.each do |tuple|
        # binding.pry
        results = results.where(query_for(tuple))
      end
      results
    end
  end

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size
  end

  # scope :search_results, -> (search_term) {where("title LIKE ? OR director LIKE ?", "%#{search_term}%", "%#{search_term}%")}

  protected

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end

  def image_size_validation
    errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
  end

end
