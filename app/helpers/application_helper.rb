module ApplicationHelper
  require 'digest/md5'
  require "lib/string"

  def title title, show_head = true
    @show_head = show_head
    content_for :title do
      title
    end
  end
  
  def javascript *content
    content_for :head do
      javascript_include_tag content
    end
  end
  
  def gravatar_image(email, name, options)
    concat image_tag(gravatar_url_for(email, options), :alt => "#{name}'s avatar", :title => "#{name}'s avatar")
    nil
  end

  def gravatar_url_for(email, options = {})
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&size=40"    
  end
  
  def redcloth_this(text)
    RedCloth.new(text).to_html
  end
  def clearfix
    "<br class='clear_both' />".html_safe
  end
  
end
