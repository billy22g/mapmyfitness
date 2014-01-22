module MapMyFitness
  class PhotoStore
    attr_reader :token, :connection

    def initialize(token)
      @token = token
      @connection = build_connection
    end

    def build_connection
      conn = Faraday.new
      conn.headers['Api-Key'] = Config.api_key
      conn.headers['Authorization'] = "Bearer #{token}"
      conn
    end

    def raw_photo_by_user(id)
      response = connection.get("https://oauth2-api.mapmyapi.com/v7.0/user_profile_photo/#{id}/?access_token=#{token}")
      JSON.parse(response.body)["_links"]["small"]
    end

    def photo_by(user_id)
      photo = raw_photo_by_user(user_id).collect do |data|
        photo = Photo.new
        photo.url = data["href"]
        photo
      end 
    end
  end
end
