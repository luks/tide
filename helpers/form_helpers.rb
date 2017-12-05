module Helpers
  module FormHelpers
    def form_error_class(object, property)
      error_class = nil
      if object.errors
        error_class = 'has-error' if object.errors[property]
      end
      error_class
    end

    def form_error_message(object, property)
      if object.errors
        if object.errors[property]
          "<small id=\"error_#{property}\" class=\"text-danger\">#{object.errors[property].join(', ')}</small>"
        end
      end
    end

    def form_tip(index)
      "<small class=\"form-text text-muted\">#{TIPS[index]}</small>"
    end

    def help_tooltip(index)
      "<span class=\"glyphicon glyphicon-info-sign text-info\" data-toggle=\"tooltip\" title=\"#{TIPS[index]}\"/></span>"
    end
  end
end
