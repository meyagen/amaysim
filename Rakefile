task :default => :test

task :test do
  Dir.glob('./tests/*.rb').each { |file| require file }
end