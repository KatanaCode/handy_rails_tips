require 'digest/md5'
module ApplicationHelper

  def title title
    content_for :title do
      title
    end

  end
  
  def gravatar_image(email, name, options)
    concat image_tag(gravatar_url_for(email, options), :alt => "#{name}'s avatar", :title => "#{name}'s avatar")
    nil
  end

  def gravatar_url_for(email, options = {})
    url_for({:gravatar_id => Digest::MD5.hexdigest(email), :host => 'www.gravatar.com', :protocol => 'http://', :only_path => false, :controller => 'avatar.php'}.merge(options)) 
  end
  
  def redcloth_this(text)
    RedCloth.new(text).to_html
  end
  
end
