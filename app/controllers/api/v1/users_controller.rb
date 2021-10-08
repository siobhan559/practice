class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user,  only: [ :show, :update ]

  def index
    @users = policy_scope(User)
    render json: @users
  end

  def show
    render json: @user
  end

  def update
    if @user.update(user_params)
      render :show
    else
      render_error
    end
  end

  def destroy
    if authorization == bearer[API_KEY]
      @user.destroy
    else
      render_error
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end

  def render_error
    render json: { errors: @user.errors.full_messages },
      status: :unprocessable_entity
  end
end
