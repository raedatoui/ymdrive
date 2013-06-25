class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :json, :html

  protected

  def load_samba_client
    if session["samba_user"] && session["samba_pass"]
      @samba_client ||= Sambal::Client.new(
        domain: 'WORKGROUP',
        host: '172.16.1.54',
        share: 'ym',
        user: session["samba_user"],
        password: session["samba_pass"],
        port: 445
      )
    else
      respond_with :connected => false
    end
  end

end
