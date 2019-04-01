class UserMailer < ApplicationMailer
  default from: "dragonballlegend0111@gmail.com"
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("mailer.activation.subject")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t("mailer.resetpass.subject")
  end
end
