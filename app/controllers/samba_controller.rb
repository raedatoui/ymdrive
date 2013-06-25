class SambaController < ApplicationController

  before_filter :load_samba_client, :only => [:index, :show,:connected, :check]


  def index
    if params[:node]
      session["samba_folder"] = params[:node]
      @samba_client.cd(session["samba_folder"])
    else
      session["samba_folder"] = ""
    end
    arr = Array.new
    @samba_client.ls.each do |k,v|
      if v[:type].to_s == "directory" && check_key(k)
        f = {:label => k, :id => session["samba_folder"] +"/"+k, :modified => v[:modified], :load_on_demand => true}
        arr.push f
      end
    end
    respond_with arr
  end

  def show
    @samba_client.cd(params[:id])
    respond_with @samba_client.ls
  end

  def connect
    puts params.inspect
    session["samba_user"] = params[:username]
    session["samba_pass"] = params[:password]
    load_samba_client
    redirect_to "/connected"
  end

  def connected
    respond_with :connected => @samba_client.connected, :username => session["samba_user"]
  end

  def check

    #respond_with @client.ask "pwd"
    @samba_client.cd("projects/condenast/Phase1")
    @samba_client.cd("..")
    st = @samba_client.ask("pwd")
    st = st.split("smb: \\")
    st = st[1].split(">")[0]
    respond_with st.split("\\")
  end

  protected

  def check_key key
    key[0] != '.' && key[0] != '$' && key != "System Volume Information"
  end

end