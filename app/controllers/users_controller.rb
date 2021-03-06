class UsersController < ApplicationController
  include CurrentCart, CategoriesAvailable
  before_action :set_cart, :categories
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
         format.html { redirect_to users_url,
          notice: "Пользователь #{@user.name} был успешно создан." }
      else
        render :new
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
         format.html { redirect_to users_url,
          notice: "Сведения о пользователе #{@user.name} были успешно обновлены." }
      else
        render :edit
      end
    end
  end

  # DELETE /users/1
  def destroy
    begin
      @user.destroy
      flash[:notice] = "Пользователь #{@user.name} удален."
    rescue StandardError => e
      flash[:notice] = e.message
    end

    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
