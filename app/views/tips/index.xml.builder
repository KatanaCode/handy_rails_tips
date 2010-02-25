xml.instruct! 
@tips.each do |tip|
  xml.tip do
    xml.id tip.id
    xml.title tip.title
    xml.url url_for(:only_path => false, :controller => "tips", :action => "show", :id => tip) 
  end
end 