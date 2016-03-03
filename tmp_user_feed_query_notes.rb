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
    @users = @user.feed_users(some_param).order('some_attr').limit(LIMIT).offset(@offset * LIMIT)

    #get the users who have liked you, and sprinkle them in
    @users_whove_liked_you = @user.inverse_likees
                              .where('users.id NOT IN (?)', params[:ids_of_users_seen_this_session]) #pass this parameter back and forth between the view, 
                                                                                                     #adding to it the ids of all of the users who have liked you 
                                                                                                     #that you have seen during this session
                              #likee_seen_count query is psuedo code, needs to be updated
                              .where('(likee_likes.match = ? AND likee_likes.likee_id = ? AND likee_likes.likee_seen_count < ?'), false, user.id, SOME_CONTSANT)
                              #the purpose of likee_seen_count query is to ensure that the same user is not being put to the top 
                              #of our feed over and over again

                              #NOTE: query above this point should be in USER MODEL

                              .shuffle(!) #from the docs
                              .limit(params[:random_limit])
                              .offset(params[:rand_offset])

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