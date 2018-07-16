class ApplicationMailer < ActionMailer::Base
  default from: ENV["mailer_gmail"]
  layout "mailer"
end
