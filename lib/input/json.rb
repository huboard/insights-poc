require 'json'

module Input
  class FromJSON

    def self.read(options)
      items = []
      Dir.glob(options['path']).each do |filepath|
        file = File.read(filepath)
        items.concat(JSON.parse(file))
      end

      if items.empty?
        $stdout.puts "Failed to read any items from #{options['path']}"
        exit 1
      end
      items 
    end
  end
end
