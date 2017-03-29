require 'errdo/notifications/rails_logger/notification_adapter'

Errdo.add_notification(:rails_logger, Errdo::Notifications::RailsLogger, notification: true)
