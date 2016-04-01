module StandupmailCli
  class Request
    def self.get_teams
      headers = { date: Time.now.httpdate }
      request = RestClient::Request.new(url: 'https://www.standupmail.com/api/external/v1/teams',
                                        headers: headers,
                                        method: :get)

      response = signed_request(request).execute
      JSON.parse(response, symbolize_names: true)
    end

    def self.post_messages(team_id, values)
      date = Time.now.httpdate
      headers = {
        content_type: 'application/json',
        date: date
      }
      request = RestClient::Request.new(url: "https://www.standupmail.com/api/external/v1/teams/#{team_id}/messages",
                                        headers: headers,
                                        method: :post,
                                        payload: values)

      signed_request(request).execute
    end

    def self.get_digest(team_id, date_range)
      start_date = date_range.first
      end_date = date_range.last
      headers = { date: Time.now.httpdate }
      request = RestClient::Request.new(url: "https://www.standupmail.com/api/external/v1/teams/#{team_id}/digests?start_date=#{start_date}&end_date=#{end_date}",
                                        headers: headers,
                                        method: :get)

      response = signed_request(request).execute
      JSON.parse(response, symbolize_names: true)
    end

    private

    def self.signed_request(request)
      ApiAuth.sign!(request, Authorization.user_token['user_access_id'],
                             Authorization.user_token['user_token'])
    end
  end
end
