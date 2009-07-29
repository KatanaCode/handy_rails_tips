module LayoutsHelper
  def subscriber_form(feed_name, options = {})
    options.symbolize_keys!
    options.reverse_merge! :label => "join mailing list", :form_id => "subscribe_form", :submit_value => "subscribe", :submit_id => "submit_subscriber", :field_name => "email", :field_id => "subscriber_email", :popup_width => 550, :popup_height => 520 
    options.assert_valid_keys(:label, :form_id, :feed_name, :submit_value, :submit_id , :field_name, :field_id, :popup_width, :popup_height)
    Markaby::Builder.new do
      form :action => "http://feedburner.google.com/fb/a/mailverify", :id => options[:form_id], 
            :method => "post", :target => "popupwindow", :onsubmit => "window.open('http://feedburner.google.com/fb/a/mailverify?uri=#{feed_name}', 'popupwindow', 'scrollbars=yes,width=#{options[:popup_width]},height=#{options[:popup_height]}');return true" do
        p do
          input :type => "text", :name => "email", :value => "subscribe via email", :onclick => "this.value='';this.style.color='#333333';", :id => options[:field_id]
          input :type => "submit", :value => options[:submit_value], :id => options[:submit_id]
          input :type => "hidden", :value => feed_name, :name => "uri"
          input :type => "hidden", :value => "en_US", :name => "loc"
        end
      end
    end
  end

  def markaby(&block)
    Markaby::Builder.new({}, self, &block)
  end
end