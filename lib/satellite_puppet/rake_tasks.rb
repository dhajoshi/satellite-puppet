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
        :push
      ].each do |t|
        Rake::Task.task_defined?("module:#{t}") && Rake::Task["module:#{t}"].clear
      end

      namespace :satellite do
        desc "Push module to the satellite"
        task :push, [:repo_id] => [:clean, :build, 'module:tag'] do |t, args|
          m = Blacksmith::Modulefile.new
          repo_id = args[:repo_id]
          satellite = SatellitePuppet::Repositories.new("#{repo_id}")
          upload_id = JSON.parse(satellite.content_uploads)["upload_id"]
          satellite.upload("#{m.name}", upload_id)
          satellite.import_uploads({:upload_ids => ["#{upload_id}"]}.to_json)
          satellite.delete upload_id
          Rake::Task['module:bump_commit'].invoke
          puts "Pushing to remote git repo"
          Blacksmith::Git.new.push!
        end
      end
    end
  end
end

SatellitePuppet::RakeTask.new
