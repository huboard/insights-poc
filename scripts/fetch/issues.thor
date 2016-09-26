module Fetch
  class Issues < Thor

    desc 'closed', 'Fetches closed issues and stores them'
    method_option :repo_paths, type: :array, required: true
    method_option :format, type: :string, default: 'JSON'
    method_option :days, type: :numeric, default: 30
    method_option :params, type: :hash, default: {}
    def closed_issues
      all_issues = []
      options['repo_paths'].each do |path|
        options['params']['state'] = 'closed'
        options['params']['since'] = Time.now - 2*options[:days]*24*60*60
        all_issues.concat(OAuth::GitHub.client.repos(path).issues(options['params']).all)
      end

      output = Object.const_get("Output::To#{options[:format]}")
      opts = send("options_for_#{options[:format].downcase}")
      output.process(all_issues, opts)
    end

    :private

    no_tasks do
      def options_for_json
        {'path' => 'issues'}
      end
    end
  end
end
