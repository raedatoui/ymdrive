class FilesController < ApplicationController

  #before_filter :load_collection
  #before_filter :load_collection , :only => [:show]
  before_filter :load_client, :only => [:show, :index, :user]

  def index
    files = @client.files("root")
    files.each do |f|
      puts f.inspect
      gfile = GFile.find_by_file_id f.id
      if gfile
        f["synced"] = true
        f["last_synced"] = gfile.last_synced
      else
        f["synced"] = false
      end
      puts f.inspect
    end
    respond_with files
    # session = GoogleDrive.login(current_user.email, "entissar151")
    # respond_with get_collections(session.collections)
  end

  def show
    files = @client.files(params[:id])
    files.each do |f|
      puts f.inspect
      gfile = GFile.find_by_file_id f["id"]
      if gfile
        f["synced"] = true
        f["last_synced"] = gfile.updated_at
      else
        f["synced"] = false
      end
      puts f.inspect
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
    render :nothing => true, :status => 200
  end

  def user
    respond_with @client.user
  end

  def sync
    GFile.create! :file_id => params[:file_id]

    render :json => {"success" => true}
  end

  private

  # def load_collection
  #   session = GoogleDrive.login(current_user.email, "entissar151")
  #   @collection = session.collection_by_title(params[:id])
  # end

  # def get_collections arr
  #   collections = Array.new
  #   arr.each do |c|
  #     collection = {}
  #     collection["name"] = c.title
  #     collection["id"] = c.resource_id
  #     collection["url"] = c.contents_url
  #     collection["type"] = "folder"
  #     collection["loaded"] = false
  #     collections.push collection
  #   end
  #   collections
  # end

  # def get_files collection
  #   files = Array.new
  #   collection.files.each do |f|
  #     file = {}
  #     file["name"] = f.title
  #     file["type"] = f.resource_type
  #     file["id"] = f.resource_id
  #     file["collection_id"] = collection.resource_id
  #     files.push file
  #   end
  #   files
  # end

  def load_client
    @client ||= Gdrive::Client.new session
  end

end
