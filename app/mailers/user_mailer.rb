class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def message_to_the_user(email, message_text)
    @text = message_text
    mail(to: email, subject: 'hi bro')
  end
end
