class UserMailer < ActionMailer::Base
  default from: "test@example.com"

  def deleted_user(user)
    @user = user
    @url = @user.email
    mail(to: @user.email, subject: "Your account has been deleted")
  end
end
