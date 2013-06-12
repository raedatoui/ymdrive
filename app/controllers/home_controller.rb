class HomeController < ApplicationController

  def index
    client = Gdrive::Client.new session
    if session == {}
      redirect_to client.api_client.authorization.authorization_uri.to_s
    else
      client.check_session
    end
  end

  def oauth
    client = Gdrive::Client.new session
    if params[:code]
        client.authorize_code params[:code]
        redirect_to '/'
    elsif params[:error] # User denied the oauth grant
      render :status => 403
    end
    # else
    #     redirect_to client.api_client.authorization.authorization_uri.to_s unless client.authorized?
    #     client.check_session
    # end
  end

  def check
    render :json => session
  end


end
