class User::SharesController < User::BaseController
  before_action :set_share, only: [:show, :edit, :update, :destroy]

  # GET /shares
  def index
    @shares = current_user.shares
  end

  # GET /shares/1
  def show
  end

  # GET /shares/new
  def new
    # pre-fill any supplied params (e.g. birth_record if creating from the birth
    # record page)
    if(params.keys.include? "share")
      @share = User::Share.new(share_params)
    else
      @share = User::Share.new
    end
    @organisations = OrganisationUser.all
  end

  # GET /shares/1/edit
  def edit
  end

  # POST /shares
  def create
    @share = User::Share.new(share_params)
    # shares are always associated with the current user
    @share.user = current_user
    @share.recipient_type = OrganisationUser.name
    
    respond_to do |format|
      if @share.save
        format.html { redirect_to @share, notice: 'Share was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /shares/1
  def update
    respond_to do |format|
      if @share.update(share_params)
        format.html { redirect_to @share, notice: 'Share was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /shares/1
  def destroy
    @share.destroy
    respond_to do |format|
      format.html { redirect_to user_shares_url, notice: 'Share was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_share
      @share = current_user.shares.find_by(params.permit(:id))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def share_params
      params.require(:share).permit(:birth_record_id, :user_id, :recipient_type, :recipient_id)
    end
end
