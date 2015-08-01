require 'rake'
require 'rake/testtask'
require 'fileutils'


namespace :cf do
  desc "INITIALIZE REPOS AND VM"
  task :init => [
    :do_update_submodules,
    :do_bundle_install
  ]
  
  # Update all the git submodules
  task :do_update_submodules do 
    puts "==> Init Git submodules"
    system "git submodule update --init --recursive"
  end
  
  # Do bundle install for all CloudFoundry components
  task :do_bundle_install do
    dirs = ["cloud_controller_ng", "dea_ng"]
    dirs.each do |dir|
      Dir.chdir dir
      unless system "bundle exec bundle install"
        raise "Bundle install at #{component_path} failed"
      end
    end
  end
  
  #Helper Functions
  def root_path
    File.expand_path("../", __FILE__)
  end

  def path(component)
    File.expand_path("../#{component}", __FILE__)
  end
end