# Creates a Rake task to limit an idempotent command to the first instance of a
# deployed application
# More here: https://docs.cloudfoundry.org/buildpacks/ruby/ruby-tips.html

namespace :cf do
  desc "Only run on the first application instance"
  task :on_first_instance do
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    exit(0) unless instance_index == 0
  end
end
