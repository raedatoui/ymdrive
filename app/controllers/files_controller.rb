class FilesController < ApplicationController

  #before_filter :load_collection
  #before_filter :load_collection , :only => [:show]
  before_filter :load_client, :only => [:show, :index, :user, :sync]

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
    # session = GoogleDrive.login(current_user.email, "entissar151")
    # respond_with get_collections(session.collections)
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
    # files = get_files @collection
    # subs = get_collections @collection.subcollections
    # respond_with  files.concat(subs)
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
    # render :nothing => true, :status => 200
  end

  def user
    respond_with @client.user
  end

  def sync
    GFile.create! :file_id => params[:file_id]
    @client.download_file params[:url]
    render :json => {"success" => true}
  end


  private

  def load_client
    @client ||= Gdrive::Client.new session
  end

end
