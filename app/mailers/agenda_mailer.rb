class AgendaMailer < ApplicationMailer
  def agenda_mail(email)
    mail to: email, subject: "アジェンダ削除のお知らせ"
  end

  def self.deliver_agenda_mails(emails)
    # self.agenda_emails(emails).map { |ae| ae.deliver }
    self.agenda_emails(emails).map(&:deliver)
  end

  def self.agenda_emails(emails)
    emails.map { |email| AgendaMailer.agenda_mail(email) }
  end
end
