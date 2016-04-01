module StandupmailCli
  class Authorization
    def self.login
      date = Time.now.httpdate
      canonical_string = ",,/api/external/v1/teams,#{date}"
      digest = OpenSSL::Digest.new('sha1')
      signature = Base64.strict_encode64(OpenSSL::HMAC.digest(digest, user_token['user_token'], canonical_string))
      headers = { 'Date' => date, 'Authorization' => "APIAuth #{user_token['user_access_id']}:#{signature}" }
      request = RestClient::Request.new(url: 'https://www.standupmail.com/api/external/v1/teams', headers: headers, method: :get)
      request.execute do |response|
        if response.code == 200
          puts 'You have been successfully logged in Standupmail.com'
        else
          puts 'Wrong token or access id, please check your configuration file in \'~/.smrc\' and try again'
        end
      end
    end

    def self.user_token
      if File.exist?(token_file_path)
        YAML.load_file(token_file_path) { %w(user_token user_access_id) }
      else
        create_new_token_file(token_file_path) { %w(user_token user_access_id) }
      end
    end

    def self.create_new_token_file(token_file_path)
      token_hash = {}
      token_hash['user_token'] = read_token_from_stdin
      token_hash['user_access_id'] = read_access_id_from_stdin
      File.open(token_file_path, 'w') { |f| f.write token_hash.to_yaml }
      token_hash
    end

    def self.read_access_id_from_stdin
      puts 'Please paste your access id: '
      STDIN.gets.chomp
    end

    def self.read_token_from_stdin
      puts 'Please paste your token: '
      STDIN.gets.chomp
    end

    def self.token_file_path
      File.expand_path('~/.smrc')
    end
  end
end
