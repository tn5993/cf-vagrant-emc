require 'rake'
require 'rake/testtask'
require 'fileutils'

RUBY_VERSION = "2.1.6"

namespace :cf do
  
  desc "INITIALIZE VM"
  task :init => [
    :do_update_submodules,
    :do_rbenv_setup,
    :do_bundle_install,
    :do_init_cloud_controller_ng
  ]
  
  task :do_update_submodules do 
    puts "==> Init Git submodules"
    system "git submodule update --init --recursive"
  end

  task :do_rbenv_setup do
    system "rbenv install #{RUBY_VERSION}" # Update ruby to 2.1.6 since cloud foundry use 2.1.6 version
    system "rbenv rehash" #Read more about rbenv on https://github.com/sstephenson/rbenv
    system "gem install bundler"
  end

  # Do bundle install for all CloudFoundry components
  task :do_bundle_install do
    dirs = [".", "src/cloud_controller_ng", "src/dea", "src/warden/warden"]
    dirs.each do |dir|
      component_path = path(dir)
      puts "Component path is #{component_path}"
      Dir.chdir component_path
      unless system "bundle install"
        raise "Bundle install at #{component_path} failed"
      end
    end
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
    Dir.chdir path('src/cloud_controller_ng')
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