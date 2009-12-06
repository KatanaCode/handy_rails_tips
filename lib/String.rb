class String  
  def remove_html
    gsub(/<\/?[\w\s\=[:punct:]]*?\s*\/?>/i, "")
  end  
end