module Helpers
  module FormHelpers
    def form_error_class(object, property)
      error_class = nil
      if object.errors
        if object.errors[property]
          error_class = 'has-error'
        end
      end
      error_class
    end

    def form_tip(index)
      "<small class=\"form-text text-muted\">#{TIPS[index]}</small>"
    end
  end
end