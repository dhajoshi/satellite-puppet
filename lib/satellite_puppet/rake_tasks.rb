require 'rake'
require 'rake/tasklib'
require 'satellite_puppet'

module SatellitePuppet
  class RakeTask < ::Rake::TaskLib

    def initialize(*args, &task_block)
      define(args, &task_block)
      #TODO may be we can modify task in Rakefile
    end
   
    def define(args, &task_block)
      [
        :push,
        :emergency
      ].each do |t|
        Rake::Task.task_defined?("module:#{t}") && Rake::Task["module:#{t}"].clear
      end

      namespace :satellite do
        desc "Push module to the satellite"
        task :push, [:repo_id] => [:clean, 'module:bump_commit', :build, 'module:tag'] do |t, args|
          m = Blacksmith::Modulefile.new
          repo_id = args[:repo_id]
          satellite = SatellitePuppet::Repositories.new("#{repo_id}")
          upload_id = JSON.parse(satellite.content_uploads)["upload_id"]
          satellite.upload("#{m.name}", "#{m.author}", upload_id)
          satellite.import_uploads({:upload_ids => ["#{upload_id}"]}.to_json)
          satellite.delete upload_id
          puts "Pushing to remote git repo"
          Blacksmith::Git.new.push!
        end

      	desc "Emergency push to life-cycle environments"
      	task :emergency, [:description, :repo_id, :environment] do |t, args|
          m = Blacksmith::Modulefile.new
          u = SatellitePuppet::Utils.new
          env_id = u.find_env_id(args[:environment])

          Rake::Task['satellite:push'].invoke("#{args[:repo_id]}")

          # Find puppet module ID in repository
          id = u.find_puppet_module_id(m.name, m.version, args[:repo_id])

          # Hack to save incremental update part, when you do publish after incremental update
          u.load_puppet_module_to_cv(m.name, m.version, id)

          # Perform incremental update
          u.perform_incremental(args[:description], id, env_id)

        end

        desc "rollback puppet module to earlier version"
        task :rollback, [:description, :repo_id, :name, :version, :environment] do |t, args|
          u = SatellitePuppet::Utils.new
          env_id = u.find_env_id(args[:environment])
          id = u.find_puppet_module_id(args[:name], args[:version], args[:repo_id])

          u.load_puppet_module_to_cv(args[:name], args[:version], id)
          u.perform_incremental(args[:description], id, env_id)
        end
      end
    end
  end
end

SatellitePuppet::RakeTask.new
