class UserMailer < ActionMailer::Base
  def message_to_the_user(email, message_text)
    @text = message_text
    mail(to: email, subject: I18n.t('message_from_IceMail'))
  end
end
