require 'rake'
require 'rake/testtask'
require 'fileutils'

DEA_PATH = "src/dea"
WARDEN_PATH = "src/warden/warden"
CLOUD_CONTROLLER_PATH = "src/cloud_controller_ng"
UAA_PATH = "src/uaa"

namespace :cf do

  desc "INITIALIZE VM"
  task :init => [
    :do_bundle_install,
    :do_init_warden,
    :do_start_cf
  ]

  task :do_update_submodules do
    puts "==> Init Git submodules"
    system "git submodule update --init --recursive"
  end

  # Do bundle install for all CloudFoundry components
  task :do_bundle_install do
    dirs = [".", CLOUD_CONTROLLER_PATH, DEA_PATH, WARDEN_PATH]
    dirs.each do |dir|
      component_path = path(dir)
      puts "Component path is #{component_path}"
      Dir.chdir component_path
      unless system "sudo bundle install"
        raise "Bundle install at #{component_path} failed"
      end
    end
  end

  desc "set up warden"
  task :do_init_warden do
    puts "==> Warden setup"
    Dir.chdir path(WARDEN_PATH)
    system "sudo bundle exec rake setup:bin[/vagrant/custom_config_files/warden/warden/test_vm.yml]"
  end

  desc "Init gorouter"
  task :do_init_gorouter do
    Dir.chdir path()
    system "go install github/cloudfoundry/gorouter"
  end

  desc "Init uaa"
  task :do_init_uaa do
    Dir.chdir path(UAA_PATH)
    system "./gradlew :cloudfoundry-identity-uaa:war"
  end

  desc "Init cloud controller"
  task :do_init_cloud_controller_ng do
    puts "==> Deleting cloud_controller_ng database."
    delete_cc_db!
    puts "==> Runing migrations cloud_controller_ng database."
    Dir.chdir path('src/cloud_controller_ng')
    system "bundle exec rake db:migrate"
  end

  desc "Set up Upstart init scripts"
  task :copy_upstart_init_scripts do
    puts "==> Copying Cloud Foundry upstart config files..."
    system "sudo cp /vagrant/upstart_configs/*.conf /etc/init"
  end

  desc "Run cf upstart job"
  task :do_start_cf => :copy_upstart_init_scripts do
    system "sudo initctl start cf"
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
