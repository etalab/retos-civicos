class EntriesController < ApplicationController
  def show
    @entry = Entry.find(params[:id])
    @challenge = @entry.challenge
    @user = @entry.member

    if !@entry.public? && !@entry.member?(current_user)
      return render status: :not_found
    end
  end

  def new
    @challenge = Challenge.find params[:challenge_id]
    redirect_if_has_submitted_app
    @entry = @challenge.entries.build
    render layout: 'aquila'
  end

  def edit
    @challenge = Challenge.find params[:challenge_id]
    @entry = Entry.find params[:id]
    render layout: 'aquila'
  end

  def create
    authorize! :create, Entry
    @challenge = Challenge.find(params[:challenge_id])
    @entry = @challenge.entries.build(params[:entry])
    if @entry.save
      redirect_to challenge_path(@entry.challenge), notice: I18n.t("flash.entries.created_successfully")
    else
      render :new, layout: 'aquila'
    end
  end

  def update
    @challenge = Challenge.find params[:challenge_id]
    @entry = Entry.find params[:id]
    authorize! :update, @entry
    if @entry.update_attributes(params[:entry])
      redirect_to challenge_path(@entry.challenge), notice: I18n.t("flash.entries.updated_successfully")
    else
      render :edit, layout: 'aquila'
    end
  end

  private

  def redirect_if_has_submitted_app
    if current_user.userable.has_submitted_app?(@challenge)
      redirect_to challenge_path(@challenge), notice: I18n.t("flash.unauthorized.already_submited_app")
    end
  end
end
