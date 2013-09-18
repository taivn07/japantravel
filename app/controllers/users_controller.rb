class UsersController < ApplicationController
  require_authenticate except: [:login_with_facebook]

  def login_with_facebook
    return head :bad_request unless
      params.has_key?(:name) &&
      params.has_key?(:facebook_id) &&
      params.has_key?(:facebook_access_token) &&
      params.has_key?(:avatar)

    user = User.login_or_create({
      name: params[:name],
      facebook_id: params[:facebook_id],
      facebook_access_token: params[:facebook_access_token],
      avatar: params[:avatar],
    })

    if user.persisted?
      respond_to_client user: user
    else
      respond_to_client nil, user.errors
    end
  end

  def logout
    if current_user.update_attributes access_token: nil
      respond_to_client
    else
      respond_to_client nil, current_user.errors
    end
  end

  def delete
    if current_user.delete
      respond_to_client
    else
      respond_to_client nil, current_user.errors
    end
  end

end
