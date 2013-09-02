namespace :logs do
  task :cleanup do
    FileUtils.rm_rf('log/raw_data')
  end
end
