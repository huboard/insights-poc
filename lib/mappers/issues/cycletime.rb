require 'date'

module Mappers
  module Issues
    class Cycletime 
      #TODO Refactor as DSL style mapper, for POC this mess is fine though

      def self.map(issues)
        mapped_issues = issues.map do |issue|
          mapped_issue = {}
          mapped_issue['Id'] = issue['id']
          mapped_issue['Title'] = issue['title']
          mapped_issue['StartDate'] = start_date(issue['events'])
          mapped_issue['EndDate'] = Time.parse(issue['closed_at']).strftime("%m/%d/%Y")
          mapped_issue['LeadTime'] = lead_time(mapped_issue)
          mapped_issue
        end.select{|i| i['StartDate']}
      end

      :private

      def self.start_date(events)
        start_column = /\d \- #{task_start_label}/
        start = events.find do |event|
          event['event'] == 'labeled' && event['label']['name'] =~ start_column
        end
        return nil if !start

        Time.parse(start['created_at']).strftime("%m/%d/%Y")
      end

      def self.lead_time(issue)
        return nil if !issue['StartDate']
        start = DateTime.strptime("#{issue['StartDate']} 12:00AM", "%m/%d/%Y %H:%M%p") 
        finish = DateTime.strptime("#{issue['EndDate']} 12:00AM", "%m/%d/%Y %H:%M%p") 
        (finish - start).to_i
      end

      def self.task_start_label
        ENV['LEADTIME_START_LABEL'] || 'Working'
      end
    end
  end
end
