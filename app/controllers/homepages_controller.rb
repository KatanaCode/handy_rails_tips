class HomepagesController < ApplicationController
  
  caches_page :about
  
  def index
    @tips = Tip.for_public.all( :limit => 5, :order => "created_at DESC")
  end
  
  def about
    @externals_hash = { 
      "CodeRay"       => "http://coderay.rubychan.de/",
      "RedCloth"      => "http://redcloth.org/",
      "Rspec"         => "http://rspec.info/",
      "WebRat"        => "https://webrat.lighthouseapp.com/dashboard",
      "Cucumber"      => "http://cukes.info/",
      "Coffee"        => "http://en.wikipedia.org/wiki/Coffee"
    }
  end
  
end
