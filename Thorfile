require 'ghee'
require 'dotenv'
Dotenv.load

#Ensure ghee has required configuration
if !ENV['GITHUB_ACCESS_TOKEN']
  $stdout.puts 'MISSING CONFIG:'
  $stdout.puts 'GITHUB_ACCESS_TOKEN missing from .env file'
  exit 1
end

#Load Lib
require_relative 'lib/lib'

#Load Scripts
Dir.glob('scripts/**/*.thor') do |f|
  Thor::Util.load_thorfile(f)
end
