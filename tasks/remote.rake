require 'yaml'

namespace :remote do

  def ssh_host
    "#{@remote_username}@#{@remote_host}"
  end

  task :config do
    staging_yaml = File.dirname(__FILE__) + '/../../../../config/pathf_staging.yml'
    config = YAML.load_file(staging_yaml)
    @remote_username = config['remote_username']
    @remote_host = config['remote_host']
    @remote_directory = config['remote_directory']
    @remote_port = config['remote_port']
  end

  task :rsync => :config do
    #%w{app config db lib public script vendor Rakefile}.each do |dir|
    #  sh "rsync -az #{dir} #{@remote_username}@#{@remote_host}:#{@remote_directory}"
    #end
    sh "rsync -az . #{ssh_host}:#{@remote_directory}"
  end
  
  task :ssh => :config do
    sh "ssh #{ssh_host}"
  end
  
  task :db_migrate => :config do
    sh "ssh #{ssh_host} 'cd #{@remote_directory}; rake db:migrate'"
  end
  
  task :mongrel_start => :config do
    sh "ssh #{ssh_host} 'cd #{@remote_directory}; mongrel_rails start -d -p #{@remote_port} -e staging'"
  end
  
  task :mongrel_stop => :config do
    sh "ssh #{ssh_host} 'cd #{@remote_directory}; mongrel_rails stop'"
  end
  
  task :mongrel_restart => :config do
    sh "ssh #{ssh_host} 'cd #{@remote_directory}; mongrel_rails restart'"
  end
  
  task :deploy => [:rsync, :mongrel_restart]
  
  task :start => [:rsync, :mongrel_start]
  
  task :destroy => :config do
    sh "ssh #{ssh_host} 'rm -rf #{@remote_directory}'"
  end
  
  task :rebuild => [:mongrel_stop, :destroy, :rsync, :mongrel_start]
  
end