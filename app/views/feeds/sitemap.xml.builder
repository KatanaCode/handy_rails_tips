xml.instruct! 
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do 
  @tips.each do |tip| 
    xml.url do 
      xml.loc url_for(:only_path => false, :controller => "tips", :action => "show", :id => tip) 
      xml.lastmod tip.updated_at.xmlschema 
    end 
  end 
end