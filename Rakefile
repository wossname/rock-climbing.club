task default: :build

task :build do
  sh 'bundle exec middleman build'
end

task deploy: :build do
  sh 'bundle exec middleman sync'
  sh 'bundle exec middleman invalidate'
end
