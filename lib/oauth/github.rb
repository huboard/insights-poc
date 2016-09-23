module OAuth
  class GitHub

    def self.client
      @client ? @client : Ghee.access_token(ENV['GITHUB_ACCESS_TOKEN'])
    end
  end
end
