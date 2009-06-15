module TipsHelper
  require 'RedCloth'
  require 'coderay'
  LANGS = %w( ruby rhtml css yaml )
  
  CODE_RAY_SETTINGS = {
      :tab_width => 2,          # convert tabs to n spaces (default is 8)
      :css => :class,           # style with css classes or inline style attributes (default is class)
      :wrap => :div,            # wraps the code in :span, :div, :page or nil (default is nil)
      :level => :xhtml,         # reserved for future use
      :line_numbers => nil,     # display line numbers as table, list, inline or nil (default is nil)
      :line_number_start => 1,  # sets which number to start line numbers on (default 1)
      :bold_every => 10,        # make the line numbers bold every nth number (default 10)
      :hint => false            # shows some info about the tag using title attributes [:info, :long_info, :debug or false]  (default false)
  }
  
  def tip_body(body) # => main method called from view
    body = wrap_in_braces(body)
    xml_to_braces(body)
    strip_html_and_convert_to_redcloth(body)
    LANGS.each {|language| code_ray_this(body, language)}
    body
  end
  
  def partial_tip_body(body)
    body = wrap_in_braces(body)
    xml_to_braces(body)
    strip_html_and_convert_to_redcloth(body)
    remove_braces(body)
  end
  
  
  

  protected
  
  def wrap_in_braces(body)
    "[text]#{body}[/text]"
  end
  
  def xml_to_braces(body)
    LANGS.each do |l| 
      body.gsub!(Regexp.new("<#{l}>"), "[/text][#{l}]")
      body.gsub!(Regexp.new("<\/#{l}>"), "[/#{l}][text]")
    end
  end
  
  def reg_expression_for(lang)
    Regexp.new("\\[#{lang.to_s}\\](\[\\w\\s[:punct:]]*?)\\[\\\/#{lang.to_s}\\]", true)
  end
  
  def strip_html_and_convert_to_redcloth(body)
    body.gsub!(reg_expression_for(:text)) { RedCloth.new($1.remove_html).to_html }
  end
  
  def code_ray_this(body, language)   
    body.gsub!(reg_expression_for(language)) { "\n\n<div class=\"#{language}_code\">" + CodeRay.scan($1, language).div(CODE_RAY_SETTINGS) + "</div>\n\n" }
  end
  
  def remove_braces(body)
    body.gsub(/\[\/?[\w]+\]/, "")
  end

end