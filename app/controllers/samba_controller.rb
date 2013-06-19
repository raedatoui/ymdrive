class SambaController < ApplicationController

  before_filter :load_client, :only => [:index, :show,:connected]


  def index
    arr = Array.new
    @client.ls.each do |k,v|
      puts k[0]
      if v[:type].to_s == "directory" && check_key(k)
        f = {:title => k, :modified => v[:modified]}
        arr.push f
      end
    end
    respond_with arr
  end

  def show
    @client.cd(params[:id])
    respond_with @client.ls
  end

  def connect
    puts params.inspect
    session["samba_user"] = params[:username]
    session["samba_pass"] = params[:password]
    load_client
    redirect_to "/connected"
  end

  def connected
    respond_with :connected => @client.connected, :username => session["samba_user"]
  end

  private

  def load_client
    if session["samba_user"] && session["samba_pass"]
      @client ||= Sambal::Client.new(
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

    def check_key key
      key[0] != '.' && key[0] != '$' && key != "System Volume Information"
    end

  end

end