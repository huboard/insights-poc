require 'fileutils'

module Output
  class ToJSON
    def self.process(items, options)
      prep_destination_dir options['path']
      json = items.to_json
      write_to_disk json, options['path']
    end

    :private

    def self.prep_destination_dir(path)
      FileUtils.mkdir_p "#{Configuration::ROOT}/output/#{path}"
      FileUtils.rm_rf Dir.glob("#{Configuration::ROOT}/output/#{path}/*")
    end

    def self.write_to_disk(json, path)
      stamp = Time.now
      filename = "#{Configuration::ROOT}/output/#{path}/#{Time.now}.json"
      File.open(filename, 'w') do |file|
        file.write(json)
      end

      $stdout.puts "Success!\n#{filename} saved"
    end
  end
end
