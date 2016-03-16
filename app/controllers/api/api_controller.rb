# NOTE: following bash command needed to access rails localhost via port:
 # rails s -b (ip_address) -p 3000 -e development

class Api::ApiController < ActionController::Base
  # before_action :authenticate
  

  private 
  # def authenticate
  #   api_token = request.headers['HTTP_AUTHORIZATION']
  #   user_id = params[:user_id] || params[:users].try(:[], :id)

  #   @user = User.find_by(api_token: api_token, id: user_id) if api_token
  #   unless @user
  #     head status: :unauthorized
  #     return false
  #   end
  # end

  def strip_params params
    params.each do |attr,value|
      value.strip! if value.respond_to?('strip')
    end
  end
end 