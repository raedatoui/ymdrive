class SambaController < ApplicationController

  before_filter :load_client, :only => [:index, :show,:connected, :check]


  def index
    if params[:node]
      session["samba_folder"] = params[:node]
      @client.cd(session["samba_folder"])
    else
      session["samba_folder"] = ""
    end
    arr = Array.new
    @client.ls.each do |k,v|
      if v[:type].to_s == "directory" && check_key(k)
        f = {:label => k, :id => session["samba_folder"] +"/"+k, :modified => v[:modified], :load_on_demand => true}
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

  def check

    #respond_with @client.ask "pwd"
    @client.cd("projects/condenast/Phase1")
    @client.cd("..")
    st = @client.ask("pwd")
    st = st.split("smb: \\")
    st = st[1].split(">")[0]
    respond_with st.split("\\")
  end

  private
  def get_full_path

  end

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