require 'csv'

module Export
  class Issues < Thor

    desc 'to_csv', 'reads issues, maps, and exports them to csv'
    method_option :format, type: :string, default: 'JSON'
    method_option :mapper, type: :string, default: 'leadtime'
    method_option :params, type: :hash, default: {}
    def to_csv
      opts_read = send("options_for_#{options[:format].downcase}_read")
      input = Object.const_get("Input::From#{options[:format]}")
      issues = input.read opts_read

      csv_friendly_array = Mappers::Issues::Leadtime.map(issues)
      Output::ToCSV.process csv_friendly_array, 'csv/issues/leadtime'
    end

    :private

    no_tasks do
      def options_for_json_read
        {'path' => 'output/enriched_issues/*.json'}
      end
    end
  end
end
