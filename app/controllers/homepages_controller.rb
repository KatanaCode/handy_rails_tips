class HomepagesController < ApplicationController
  
  
  def index
    @tips = Tip.for_public.all# :limit => 5
  end
  
  def about
    unless read_fragment("about")
      @externals_hash = { "CodeRay"       => "http://coderay.rubychan.de/",
		                    "RedCloth"      => "http://redcloth.org/",
                        "Rspec"         => "http://rspec.info/",
                        "WebRat"        => "https://webrat.lighthouseapp.com/dashboard",
                        "Cucumber"      => "http://cukes.info/",
                        "Coffee"        => "http://en.wikipedia.org/wiki/Coffee"}
    end
  end
  
  def notice;end
  
  def terms;end
  
  def advertise;end

  def help;end
  
  def contribute;end
end
