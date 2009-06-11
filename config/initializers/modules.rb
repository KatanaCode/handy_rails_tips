module UrlSorter
  
  def add_protocol
    if self.url.empty? || self.url =~ URL_FORMAT
      self.url
    else
      self.url = "http://#{self.url}"
    end
  end
  
end