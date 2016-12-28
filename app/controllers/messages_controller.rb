class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :status ]
  before_filter :authenticate_user!
  before_filter :collect_states, only: [:create, :message_user, :index, :sorting, :sorting_by_month]
  before_filter :for_user, only: [:edit, :create, :send_message, :message_user, :index, :sorting, :sorting_by_month]
  before_filter :group_state, only: [:create, :message_user, :index, :sorting]

  # GET /messages
  # GET /messages.json

  def index
  end

  def offseted_time(offset)
    @time_beginning = Time.now.beginning_of_month-offset.months
  end

  def sorting_by_month
    @messages = []
    6.times.each do |i|
      @messages[i] = [offseted_time(i), @for_user.where(created_at: (offseted_time(i)).to_s..(offseted_time(i) + 1.month).to_s).group_by { |hsh| hsh[:aasm_state] }]
    end
  end

  def status
    if @message.working?
      @message.complete
    elsif @message.new?
      @message.work
    end
    render 'edit'
  end

  def send_message
  end

  def message_user
    message = @for_user.find_by(id: params[:id])
    return redirect_to :index unless message
    UserMailer.message_to_the_user(message.email, params[:message_user]).deliver
    render 'index'
  end

  def sorting
    if params[:sort] == 'aasm_state'
      @messages = []
      @states.each do |status|
        @messages += @for_user.for_state(status)
      end
      @messages = Kaminari.paginate_array(@messages).page(params[:page]).per(15)
    else
      @messages = @for_user.order(params[:sort]).page params[:page]
    end
    render 'index'
  end

  def check
    @message = Message.find_by(email: params[:checking_email])
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
    message = @for_user.find_by(id: params[:id])
    return redirect_to :index unless message
    @available_states = [[message.aasm_state, message.aasm_state]]
    @available_states += message.aasm.states(permitted:true).map{|state|[state.name,state.name]}
  end

  # POST /messages
  # POST /messages.json
  def create
    @message =  current_user.messages.new(message_params)
    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_path, notice: I18n.t('message_created') }
        format.json { head :no_content }
        format.js {}
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        format.js { render partial: 'message_errors'  }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to messages_path, notice: I18n.t('message_updated') }
        format.json { head :no_content }
        format.js {}
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

    def for_user
      @for_user = Message.for_user(current_user)
      @messages = @for_user.order(created_at: :desc).page(params[:page])
    end

    def collect_states
      @states = Message.aasm.states.map{|state| state.name.to_s}
    end

    def group_state
      @group_state = @for_user.group(:aasm_state).count
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:employee, :url, :email, :commit, :time_now, :aasm_state)
    end
end
