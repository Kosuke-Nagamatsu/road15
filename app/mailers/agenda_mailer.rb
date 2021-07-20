class AgendaMailer < ApplicationMailer
  def agenda_mail(email)
    mail to: email, subject: "アジェンダ削除のお知らせ"
  end
end
