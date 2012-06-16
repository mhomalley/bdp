module ActionView
  module Helpers
    module FormHelpers
      def label_for(object_name, method, options = {})
	InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_label_tag(options)
      end
    end

    class InstanceTag
      def to_label_tag(options = {})
	temp_options = {}
	add_default_name_and_id(temp_options)
	if not options.has_key?(:for)
	  options[:for] = temp_options['id']
	end
	content_tag('label', options.delete(:text) || @method_name.humanize, options)
      end
    end

    class FormBuilder
      def label_for(method, options = {})
	@template.label_for(@object_name, method, options.merge(:object => @object))
      end
    end
  end
end
