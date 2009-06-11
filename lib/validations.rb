module ActiveRecord
  module Validations
    module ClassMethods
      
      def validates_permitted(attribute, options = { :message => "is not permitted"})
        options.to_options!
        options.assert_valid_keys(:message, :in)
        raise ":in must be specified" if options[:in].nil?
        validate do |obj|
          options[:in].each do |reserved|
            obj.errors.add(attribute, options[:message]) if obj.send(attribute) == reserved
          end
        end
      end
      
    end
  end
end