begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  RSpec::Core::RakeTask.new(:'spec:unit') do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:'spec:int') do |t|
    t.pattern = "spec/integration/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/}
  end
rescue LoadError
  $stderr.puts 'Warning: RSpec not available.'
end
