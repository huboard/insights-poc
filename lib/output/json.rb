require 'fileutils'

module Output
  class ToJSON
    def self.process(issues)
      prep_destination_dir
      json = issues.to_json
      write_to_disk json
    end

    :private

    def self.prep_destination_dir
      FileUtils.mkdir_p "#{Configuration::ROOT}/output/issues"
      FileUtils.rm_rf Dir.glob("#{Configuration::ROOT}/output/issues/*")
    end

    def self.write_to_disk(json)
      stamp = Time.now
      filename = "#{Configuration::ROOT}/output/issues/#{Time.now}.json"
      File.open(filename, 'w') do |file|
        file.write(json)
      end

      $stdout.puts "Success!\nWrote #{filename} to #{Configuration::ROOT}"
    end
  end
end
