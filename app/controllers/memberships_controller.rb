class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all.reject{ |club| current_user.in? club.members }
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    club = BeerClub.find membership_params[:beer_club_id]
    if not current_user.in? club.members and @membership.save
      current_user.memberships << @membership
      @membership.confirmed = false
      @membership.save
      redirect_to beer_club_path(membership_params[:beer_club_id]), notice: "#{current_user.username}, your application to the club #{@membership.beer_club.name} has been sent!"
    else
      @clubs = BeerClub.all
      render :new
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    bc = @membership.beer_club
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Membership in #{bc.name} beerclub ended." }
      format.json { head :no_content }
    end
  end

  def toggle_confirmed
    membership = Membership.find(params[:id])
    membership.update_attribute :confirmed, (not membership.confirmed)

    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id)
    end
end
