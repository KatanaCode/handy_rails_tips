xml.instruct!
xml.rss "version" => "2.0",
        "xmlns:dc" => "htt://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title @tip.title
    xml.description "#{@tip.title}: comments"
    xml.pubDate CGI.rfc1123_date @comments.first.created_at if @comments.any?
    xml.link url_for :only_path => false, :controller => 'tips'
    xml.guid url_for :only_path => false, :controller => 'tips'                  
    xml.lastBuildDate CGI.rfc1123_date @comments.first.created_at if @comments.any?
    xml.language "en"
    @comments.each do |comment|
      xml.item do
        xml.title @tip.title
        xml.description comment.body
        xml.link url_for :only_path => false,
                          :controller => 'tips',
                          :action => 'show',
                          :id => @tip
        xml.pubDate CGI.rfc1123_date @tip.updated_at
        xml.guid url_for :only_path => false,
                         :controller => 'tips',
                         :action => 'show',
                         :id => @tip
        xml.author comment.name
      end
    end
  end
end