class FilesController < ApplicationController

  before_filter :load_client, :only => [:show, :index, :user, :sync]
  before_filter :load_samba_client, :only => [:sync]

  def index
    files = @client.files("root")
    files.each do |f|
      gfile = GFile.find_by_file_id f.id
      if gfile
        f["synced"] = true
        f["last_synced"] = gfile.last_synced
      else
        f["synced"] = false
      end
    end
    respond_with files
  end

  def show
    files = @client.files(params[:id])
    files.each do |f|
      gfile = GFile.find_by_file_id f["id"]
      if gfile
        f["synced"] = true
        f["last_synced"] = gfile.updated_at
      else
        f["synced"] = false
      end
    end
    respond_with files
  end

  def update
    render :nothing => true, :status => 200
  end

  def create
    render :nothing => true, :status => 200
  end

  def destroy
    @gfile = GFile.find_by_file_id(params[:id])
    if @gfile
      @gfile.destroy
    end
    head :ok
  end

  def user
    respond_with @client.user
  end

  def sync

    GFile.create! :file_id => params[:file_id]
    file_body =  @client.download_file params[:url]
    if file_body
      if params[:extension]
        file_name = params[:name] + "." + params[:extension]
      else
        file_name = params[:name]
      end
      file_name = file_name.gsub /[\/]/, ' '
      puts file_name
      my_local_file = open("public/drive/#{file_name}", "wb")
      my_local_file.write(file_body)
      my_local_file.close
      @samba_client.cd("users/raed atoui/ymdrive")
      @samba_client.put("public/drive/#{file_name}",file_name)
      File.delete "public/drive/#{file_name}"
    end
    render :json => {"success" => true, "id" => params[:file_id]}
  end

  protected

  def load_client
    @client ||= Gdrive::Client.new session
  end

end
