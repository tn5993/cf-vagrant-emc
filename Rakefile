require 'rake'
require 'rake/testtask'
require 'fileutils'

namespace :host do
  task :init => [
    :do_update_submodules
  ]
  
  # Update all the git submodules
  task :do_update_submodules do 
    puts "==> Init Git submodules"
    system "git submodule update --init --recursive"
  end
end


namespace :cf do
  
  desc "INITIALIZE REPOS AND VM"
  task :init => [
    :do_bundle_install,
    :do_init_cloud_controller_ng,
  ]
  
  # Do bundle install for all CloudFoundry components
  task :do_bundle_install do
    dirs = [".","cloud_controller_ng", "dea_ng", "warden/warden"]
    
    dirs.each do |dir|
      component_path = path(dir)
      puts "Component path is #{component_path}"
      Dir.chdir component_path
      unless system "bundle install"
        raise "Bundle install at #{component_path} failed"
      end
    end
    system "rbenv rehash"
  end
  
  desc "Init uaa"
  task :do_init_uaa do
    Dir.chdir root_path + '/uaa'
    system "mvn package -DskipTests"
  end
  
  task :do_init_cloud_controller_ng do
    puts "==> Deleting cloud_controller_ng database."
    delete_cc_db!
    puts "==> Runing migrations cloud_controller_ng database."
    Dir.chdir path('cloud_controller_ng')
    system "bundle exec rake db:migrate"
  end
  
  
  #Helper Functions
  def root_path
    File.expand_path("../", __FILE__)
  end

  def path(component)
    File.expand_path("../#{component}", __FILE__)
  end
  
  def delete_cc_db!
    cc_db_file = "#{root_path}/db/cloud_controller.db"
    File.delete cc_db_file if File.exists? cc_db_file
  end
end