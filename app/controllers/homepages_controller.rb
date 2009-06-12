class HomepagesController < ApplicationController
  def index
    @tips = Tip.for_public.all :limit => 5
  end
  
  def about
    @externals_hash = { "CodeRay"       => "http://coderay.rubychan.de/",
		                    "RedCloth"      => "http://redcloth.org/",
                        "Rspec"         => "http://rspec.info/",
                        "WebRat"        => "https://webrat.lighthouseapp.com/dashboard",
                        "Cucumber"      => "http://cukes.info/",
                        "ZenTest"       => "http://www.zenspider.com/ZSS/Products/ZenTest/",
                        "SimpleCaptcha" => "http://simplecaptcha.sourceforge.net/",
                        "Coffee"        => "http://en.wikipedia.org/wiki/Coffee"}
  end
  
  def notice
    
  end
  
  def terms
    
  end
  
  def advertise
    
  end

  def help
    
  end
  
  def contribute
    
  end
end
