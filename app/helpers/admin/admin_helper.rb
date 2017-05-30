module Admin
  module AdminHelper
    def admin_flash_message
      messages = []
      if flash[:notice].present?
        messages << {
                     class: "success",
                     text: flash[:notice]
                    }
      end

      if flash[:alert].present?
        messages << {
                     class: "error",
                     text: flash[:alert]
                    }
      end

      if flash[:error].present?
        messages << {
                     class: "error",
                     text: flash[:error]
                    }
      end

      html = ""

      messages.each do |message|
        html << %Q(
          <div class="ui #{message[:class]} message">
            #{message[:text]}
          </div>
        )
      end

      html.html_safe
    end
  end
end
