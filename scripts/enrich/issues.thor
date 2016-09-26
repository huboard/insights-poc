module Enrich
  class Issues < Thor

    desc 'events', 'Reads in issues and enriches them with timeline data'
    method_option :format, type: :string, default: 'JSON'
    method_option :params, type: :hash, default: {}
    def events 
      opts_read = send("options_for_#{options[:format].downcase}_read")
      input = Object.const_get("Input::From#{options[:format]}")
      issues = input.read opts_read

      issues.each do |issue|
        repo_name = repo_name issue
        events = OAuth::GitHub.client.repos(repo_name).issues(issue['number']).events
        issue["events"] = events
      end

      output = Object.const_get("Output::To#{options[:format]}")
      opts = send("options_for_#{options[:format].downcase}_write")
      output.process(issues, opts)
    end

    :private

    no_tasks do
      def repo_name(issue)
        matcher = /repos\/(?<repo_name>.*)/
        repo_url = issue['repository_url']
        repo_url.match(matcher)[:repo_name]
      end

      def options_for_json_read
        {'path' => 'output/issues/*.json'}
      end

      def options_for_json_write
        {'path' => 'issues/enriched_issues'}
      end
    end
  end
end
