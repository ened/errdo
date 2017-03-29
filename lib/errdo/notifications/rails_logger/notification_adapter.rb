require_relative '../../helpers/views_helper.rb'

module Errdo
  module Notifications
    module RailsLogger

      class NotificationAdapter

        def initialize(options = {})
        end

        def notify(parser, options = nil)
          messager = RailsLogMessager.new(parser, options)

          Rails.logger.error messager.message
        end

      end

      class RailsLogMessager

        include Errdo::Helpers::ViewsHelper # For the naming of the user in the message

        def initialize(parser, options = nil)
          @user = parser.user
          @backtrace = parser.short_backtrace
          @exception_name = parser.exception_name
          @exception_message = parser.exception_message
          @error = options ? options[:error] : nil
        end

        def message
          url_helpers = Errdo::Engine.routes.url_helpers
          error_url = url_helpers.error_url(@error) if @error
          
          m = <<-EOF
#{exception_string}
#{@exception_message}
Link: #{error_url}
#{additional_fields.map { |f| "#{f[:title]}: #{f[:value]}\n"}.join("\n")}
EOF
        end

        private

        def exception_string
          @exception_name || 'None'
        end

        def additional_fields
          fields = [{ title: "Backtrace",
                      value: @backtrace.to_s }]
          if @user
            fields += [{ title: "User Affected",
                         value: user_show_string(@user) }]
          end
          return fields
        end

      end
    end
  end
end
