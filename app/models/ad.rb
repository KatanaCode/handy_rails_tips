class Ad < ActiveRecord::Base  
  include UrlSorter
  
  before_save :strip_company
  before_save :add_position
  
  before_save :add_protocol
    
  after_save :write_image_file
 
  after_destroy :delete_image_file
  
  validates_presence_of :company
  
  validates_presence_of :image, :on => :create
  
  validates_presence_of :url


  def image=(image)
    @image = image
  end
  
  def image
    @image == "" ? nil : @image
  end
  
  def image_path
    "ads/#{id}.png"
  end
  

  
  protected
  
  WIDTH = 160
  
  def add_position
    self.position = Ad.count+1
  end
  
  def write_image_file
    return if RAILS_ENV == 'test'
    if image
      img = Image.from_blob(image.read).first
      img.resize_to_fit!(WIDTH) # => 160px
      img.write("#{RAILS_ROOT}/public/images/ads/#{id}.png")
    end
  end
  
  def delete_image_file
    if File.exist?("#{RAILS_ROOT}/public/images/#{image_path}")
      File.delete("#{RAILS_ROOT}/public/images/#{image_path}")
    end
  end
  
  def strip_company
    self.company.strip!
  end
end
