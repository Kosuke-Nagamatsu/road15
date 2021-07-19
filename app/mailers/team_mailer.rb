class TeamMailer < ApplicationMailer
  def team_mail(user)
    @user = user
    mail to: @user.email, subject: "リーダー権限の変更のお知らせ"
  end
end
