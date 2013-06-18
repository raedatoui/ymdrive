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
    @gfile = GFile.find_by_file_id(params[:id])
    @gfile.destroy
    head :ok
    # render :nothing => true, :status => 200
  end

  def user
    respond_with @client.user
  end

  def sync
    GFile.create! :file_id => params[:file_id]

    render :json => {"success" => true}
  end

  def samba
  client = Sambal::Client.new(domain: 'WORKGROUP', host: '172.16.1.54', share: 'ym', user: 'raed', password: 'entissar151', port: 445)
   # returns hash of files
  # client.put("local_file.txt","remote_file.txt") # uploads file to server
  # client.put_content("My content here", "remote_file") # uploads content to a file on server
  # client.get("remote_file.txt", "local_file.txt") # downloads file from server
  # client.delete("remote_file.txt") # deletes files from server
  client.cd("users/christian johansson") # changes directory on server
  f = client.ls
  client.close # closes connection
  render :json => f
  end

  private

  def load_client
    @client ||= Gdrive::Client.new session
  end

end
