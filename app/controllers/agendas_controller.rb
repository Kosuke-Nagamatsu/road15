class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    user_ids = Assign.all.where(team: @agenda.team).pluck(:user_id)
    emails = user_ids.map { |user_id| User.all.find(user_id).email }
    if current_user == @agenda.user || current_user == @agenda.team.owner
      @agenda.destroy
      binding.irb
      emails.each do |email|
        AgendaMailer.agenda_mail(email).deliver
      end
      redirect_to dashboard_url, notice: I18n.t('views.messages.delete_agenda')
    else
      redirect_to team_path(@agenda.team), notice: I18n.t('views.messages.cannot_delete_agenda')
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
