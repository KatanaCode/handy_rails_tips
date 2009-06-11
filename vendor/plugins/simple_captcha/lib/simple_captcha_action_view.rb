# Copyright (c) 2008 [Sur http://expressica.com]

module SimpleCaptcha #:nodoc
  module ViewHelpers #:nodoc
    
    include ConfigTasks

    def show_simple_captcha(options={})
      options[:field_value] = set_simple_captcha_data(options[:code_type])
      @simple_captcha_options = 
        {:image => simple_captcha_image(options),
         :label => options[:label] || "(type the code from the image)",
         :field => simple_captcha_field(options)}
      render :partial => 'simple_captcha/simple_captcha'
    end

    private

    def simple_captcha_image(options={})
      url = 
        simple_captcha_url(
          :action => 'simple_captcha',
          :simple_captcha_key => simple_captcha_key,
          :image_style => options[:image_style] || '', 
          :distortion => options[:distortion] || '',
          :time => Time.now.to_i)
      "<img src='#{url}' alt='simple_captcha.jpg' />"
    end
    
    def simple_captcha_field(options={})
      options[:object] ?
      text_field(options[:object], :captcha, :value => '') +
      hidden_field(options[:object], :captcha_key, {:value => options[:field_value]}) :
      text_field_tag(:captcha)
    end

    def set_simple_captcha_data(code_type)
      key, value = simple_captcha_key, generate_simple_captcha_data(code_type)
      data = SimpleCaptchaData.get_data(key)
      data.value = value
      data.save
      key
    end
 
    def generate_simple_captcha_data(code)
      value = ''
      case code
      when 'numeric'
        6.times{value << (48 + rand(10)).chr}
      else
        6.times{value << (65 + rand(26)).chr}
      end
      return value
    end
 
  end
end

ActionView::Base.module_eval do
  include SimpleCaptcha::ViewHelpers
end
