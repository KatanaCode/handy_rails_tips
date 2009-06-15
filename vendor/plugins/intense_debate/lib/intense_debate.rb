module IntenseDebate
  module ViewHelpers
    def intense_debate_comments(obj, options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:acct_no, :url, :title)
      # options[:acct_no] takes priority over ID_ACCT_NO
      options[:acct_no] = acct_no unless options[:acct_no]
      raise ArgumentError, "You must specify an IntenseDebate account number", options if options[:acct_no].nil?
      raise "Intense Debate account no. doesn't look valid" unless options[:acct_no] =~ /[\w]{32}/ # => ensure the account no is valid
      options[:url].is_a?(String) # => ensure the url is a string
      options[:title].is_a?(String) # => ensure the url is a string
      concat "<script>\n"
      concat "  var idcomments_acct = '#{options[:acct_no]}';\n"
      concat "  var idcomments_post_id = '#{obj.id}';\n"
      concat "  var idcomments_post_url = '#{options[:url]}';\n"
      concat "  var idcomments_post_title = '#{options[:title]}';\n"
      concat "</script>\n"
      concat "<span id='IDCommentsPostTitle' style='display:none'></span>\n"
      concat "<script type='text/javascript' src='http://www.intensedebate.com/js/genericCommentWrapperV2.js'></script>\n"
      nil
    end

    def comments_count_link(obj, options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:acct_no, :url)
      # options[:acct_no] takes priority over ID_ACCT_NO
      options[:acct_no] = acct_no unless options[:acct_no]
      raise ArgumentError, "You must specify an IntenseDebate account number", options if options[:acct_no].nil?
      raise "Intense Debate account no. doesn't look valid" unless options[:acct_no] =~ /[\w]{32}/ # => ensure the account no is valid
      options[:url].is_a?(String) # => ensure the url is a string
      options[:title].is_a?(String) # => ensure the url is a string
      concat "<script>\n"
      concat "  var idcomments_acct = '#{options[:acct_no]}';\n"
      concat "  var idcomments_post_id = '#{obj.id}';\n"
      concat "  var idcomments_post_url = '#{options[:url]}';\n"
      concat "  var idcomments_post_title = '#{options[:title]}';\n"
      concat "</script>\n"
      concat "<script type=\"text/javascript\" src=\"http://www.intensedebate.com/js/genericLinkWrapperV2.js\"></script>\n"
      nil
    end
    
    protected
    
    def acct_no
      ApplicationController::ID_ACCT_NO
    end
  end
  
end


# <script>
# var idcomments_acct = 'f6f857ecb1bf718d7c85b1170bf9bbf8';
# var idcomments_post_id;
# var idcomments_post_url;
# </script>
# <span id="IDCommentsPostTitle" style="display:none"></span>
# <script type='text/javascript' src='http://www.intensedebate.com/js/genericCommentWrapperV2.js'></script>
