# Populate feed Query: 
user = User.find(params[:usre][:id])
miles = 10
your_sex = "female"
interested_in = "men"

class FeedsController
 def index
    #TODO -- APP REMINDER -- ensure proper likee_seen_counts are updated on viewDisDisappear of the feedView

    @users = @user.feed_users(params[:radius]).order('some_attr').limit(LIMIT).offset(@offset * LIMIT)

    #get the users who have liked you, and sprinkle them in
    @users_whove_liked_you = @user.recent_inverse_likees(params[:seen_this_session_ids])
                              .order('random()')
                              .limit(params[:random_limit]) # keep track of this in swift
                              .offset(params[:rand_offset]) # keep track of this in swift

    users = (@users + @users_whove_liked_you).map do |user|
      {
        id: user.id,
        small_source: user.image.url(:small),
        age: user.age,
        name: user.name,
        #other attributes to return
      }
    end

    render :json => {
      users: users
    }
  end
end