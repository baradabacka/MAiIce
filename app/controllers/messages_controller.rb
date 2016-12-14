class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :status ]
  before_filter :authenticate_user!

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.for_user(current_user)
  end

  def status
    if @message.working?
      @message.complete
    elsif @message.new?
      @message.work
    end
    render 'edit'
  end

  def sorting
    # if params[:sort] == 'aasm_state'
    #   # state = Message.aasm.states.map(&:name)
    #   # @messages = Message.for_state(state[0], current_user.id).merge(Message.for_state(state[1], current_user.id)).merge(Message.for_state(state[2], current_user.id))
    # else
      @messages = Message.for_user(current_user).order(params[:sort])
    # end
    render 'index'
  end


  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message =  current_user.messages.new(message_params)
    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: I18n.t('message_created') }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: I18n.t('message_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:employee, :url, :email, :commit, :time_now, :aasm_state)
    end
end
