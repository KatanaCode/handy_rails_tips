class TipObserver < ActiveRecord::Observer
  
  require 'net/http'
  require 'uri'
  
  include ActionController::UrlWriter 
  default_url_options[:host] = 'www.handyrailstips.com' 
  
  def after_save(tip)
    if tip.state == STATES[:flagged]
      Notifier.deliver_flagged(tip)
    end
    ping_google(tip)
  end
  
  
  private
  
  
  def ping_google(tip)
    if RAILS_ENV == 'production' && tip.safe?
      response = Net::HTTP.get('www.google.com', '/ping?sitemap=' + URI.escape(sitemap_url))
      tip.logger.info "[info]Pinged Google Successfully[/info]" unless response.scan("Sitemap Notification Received").empty?
    else
      # response from google
      "<html><meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">\n<head><title>\nGoogle Webmaster Tools\n-\nSitemap Notification Received</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"/webmasters/tools/docs/css/wmt.css\">\n\n<script type=\"text/javascript\" src=\"/webmasters/tools/js/1141241933-sitemaps_js.js\"></script>\n\n<script src=\"https://ssl.google-analytics.com/urchin.js\" type=\"text/javascript\">\n    </script>\n<script type=\"text/javascript\">\n      _uacct=\"UA-18009-2\";\n      _utcp=\"/webmasters/\";\n      _uanchor=1;\n      urchinTracker();\n    </script>\n<script type=\"text/javascript\">\n      function focusWindow() {\n        var w = window.open(\"\", \"google_popup\");\n        w.focus();\n      }\n    </script>\n\n\n<meta name=\"robots\" content=\"noindex, noodp\"></head>\n<body><h2>Sitemap Notification Received</h2>\n<br>\nYour Sitemap has been successfully added to our list of Sitemaps to crawl. If this is the first time you are notifying Google about this Sitemap, please add it via  <a href=\"http://www.google.com/webmasters/tools/\">http://www.google.com/webmasters/tools/</a>  so you can track its status. Please note that we do not add all submitted URLs to our index, and we cannot make any predictions or guarantees about when or if they will appear.</body></html>"
    end
  end 
  
end
