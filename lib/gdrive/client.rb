module Gdrive
    class Client
        require 'google/api_client'
        require 'google/api_client/client_secrets'

        SCOPES = [
            'https://www.googleapis.com/auth/drive',
            'https://www.googleapis.com/auth/drive.file',
            'https://www.googleapis.com/auth/drive.readonly.metadata',
            'https://www.googleapis.com/auth/userinfo.email',
            'https://www.googleapis.com/auth/userinfo.profile',
            'https://www.googleapis.com/auth/drive.install'
        ]

        def initialize session
            @session = session
            @credentials = Google::APIClient::ClientSecrets.load
            client = Google::APIClient.new
            @drive = client.discovered_api('drive', 'v2')
            @oauth2 = client.discovered_api('oauth2', 'v2')
        end

        def authorized?
            return api_client.authorization.access_token
        end

        def sign_out

        end

        def raise_exception type, message = nil
            sign_out
            #raise Services::Exception.new(@name,type, message)
        end

        def api_client
            @client ||= (begin
                client = Google::APIClient.new
                client.authorization.client_id = @credentials.client_id
                client.authorization.client_secret = @credentials.client_secret
                client.authorization.redirect_uri = @credentials.redirect_uris.first
                client.authorization.scope = SCOPES
                @drive = client.discovered_api('drive', 'v2')
                @oauth2 = client.discovered_api('oauth2', 'v2')
                client
            end)
        end

        def authorized?
            return api_client.authorization.access_token
        end

        def authorize_code(code)
            api_client.authorization.code = code
            api_client.authorization.fetch_access_token!
            # put the tokens to the sesion
            @session[:access_token] = api_client.authorization.access_token
            @session[:refresh_token] = api_client.authorization.refresh_token
            @session[:expires_in] = api_client.authorization.expires_in
            @session[:issued_at] = api_client.authorization.issued_at
        end

        def check_session
            api_client.authorization.update_token!(@session)
            # if existing access token is expired and refresh token is set,
            # ask for a new access token.
            if api_client.authorization.refresh_token &&
                api_client.authorization.expired?
                api_client.authorization.fetch_access_token!
            else
                @session[:access_token] = api_client.authorization.access_token
                @session[:refresh_token] = api_client.authorization.refresh_token
                @session[:expires_in] = api_client.authorization.expires_in
                @session[:issued_at] = api_client.authorization.issued_at
            end
        end

        def files collection
            check_session
            result = Array.new
            page_token = nil
            begin
                parameters = {'folderId' => collection}
                if page_token.to_s != ''
                    parameters['pageToken'] = page_token
                end
                api_result = api_client.execute(
                    :api_method => @drive.children.list,
                    :parameters => parameters)
                if api_result.status == 200
                    files = api_result.data
                    #result.concat(files.items)
                    files.items.each do |f|
                        file_result = api_client.execute(
                            :api_method => @drive.files.get,
                            :parameters => { 'fileId' => f.id }
                        )
                        if file_result.status == 200
                            file = file_result.data
                            f = {}
                            f["title"] = file.title
                            f["type"] = file.mimeType.split("application/vnd.google-apps.")[1]
                            f["description"] = file.description
                            f["createdDate"] = file.createdDate
                            f["modifiedDate"] = file.modifiedDate
                            f["collection_id"] = collection
                            f["icon"] = file.iconLink
                            #f["ownerNames"] = file.ownerNames
                            f["link"] = file.alternateLink
                            f["id"] = file.id
                            result.push f
                        end
                    end
                    page_token = files.next_page_token
                else
                    puts "An error occurred: "
                    page_token = nil
                end
            end while page_token.to_s != ''
            result
        end

        def user
          result = api_client.execute(:api_method => @oauth2.userinfo.get)
          result.data
        end

    end
end
