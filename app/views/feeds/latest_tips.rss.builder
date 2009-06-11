xml.instruct!
xml.rss "version" => "2.0",
        "xmlns:dc" => "htt://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title 'Latest Tips on HandyRailsTips.com'
    xml.description 'The latest tips on HandyRailsTips.com'
    xml.pubDate CGI.rfc1123_date @tips.first.updated_at if @tips.any?
    xml.link url_for :only_path => false, :controller => 'tips'
    xml.guid url_for :only_path => false, :controller => 'tips'                  
    xml.lastBuildDate CGI.rfc1123_date @tips.first.updated_at if @tips.any?
    xml.language "en"
    @tips.each do |tip|
      xml.item do
        xml.title tip.title
        xml.description tip.short_body.remove_html
        xml.link url_for :only_path => false,
                          :controller => 'tips',
                          :action => 'show',
                          :id => tip
        xml.pubDate CGI.rfc1123_date tip.updated_at
        xml.guid url_for :only_path => false,
                         :controller => 'tips',
                         :action => 'show',
                         :id => tip
        xml.author tip.user.username
      end
    end
  end
end