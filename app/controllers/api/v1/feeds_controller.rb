class  Api::V1::FeedsController < Api::ApiController
  before_action :set_user, only: [:index]

  def index
    #TODO -- APP REMINDER -- ensure proper likee_seen_counts are updated on viewDisDisappear of the feedView
    @users = @user.feed_users(index_params[:radius]).limit(20).offset(index_params[:user_offset].to_i * 20)
    #random order is probably also needed on this query, which may require adding something like we have below w/ :recent_inverse_likees

    #get the users who have liked you, and sprinkle them in
    @users_whove_liked_you = @user.recent_inverse_likees(index_params[:seen_this_session_ids])
                              .order('random()')
                              .limit(index_params[:liked_limit]) # keep track of this in swift
                              .offset(index_params[:liked_offset]) # keep track of this in swift

    users = (@users + @users_whove_liked_you).map do |user|
      {
        id: user.id,
        age: user.birthday,
        name: user.full_name,
        #other attributes to return
      }
    end

    render :json => {
      users: users
    }
  end

  private

  def set_user
    @user = User.find_by(id: index_params[:user_id])
  end

  def index_params
    params.require(:feed).permit(
      :user_offset,
      :liked_limit,
      :liked_offset,
      :user_id,
      :radius,
    )
  end
end