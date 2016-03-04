# Populate feed Query: 
user = User.find(params[:usre][:id])
miles = 10
your_sex = "female"
interested_in = "men"

class User
  def feed_users #below is psuedo code
    .within(miles, origin: {lat: self.lat, lng: self.lng})
    .where({
      interested_in: self.your_sex,
      sex: self.interested_in,
    })
    .where('id NOT IN (?)', self.likees.pluck(:id)) #TODO: possible to avoid likees query in future?
  }
end

class FeedsController
 def index
    @users = @user.feed_users(params[:radius]).order('some_attr').limit(LIMIT).offset(@offset * LIMIT)

    #get the users who have liked you, and sprinkle them in
    @users_whove_liked_you = @user.recent_inverse_likees(params[:seen_this_session_ids])
                              .order('random()') # must switch to postgres for this to work
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