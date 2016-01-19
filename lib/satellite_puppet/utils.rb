module SatellitePuppet
  class Utils

    # Find Environment ID from environment name
    def find_env_id(env_names)
      begin
        organizaton_id = SatellitePuppet::sat_organization_id
      rescue
        puts "sat_organization_id is not defined in config file"
      end

      env_list = {}

      results = JSON.parse(SatellitePuppet::Organizations.new(organization_id).environments)["results"]

      results.each do |result|
        env_list[result['id']] = result['name']
      end

      env_id = []
      env_names = env_names.split(' ')
      env_names.each do |env|
        env_id.push(env_list.key(env).to_s)
      end

      return env_id
    end

    # Find content view version ID
    def find_cv_version_id
      begin
        cv = SatellitePuppet::sat_content_view
      rescue => e
        puts "check 'sat_content_view' in config file"
      end
      versions = JSON.prase(SatellitePuppet::Content_views.new(cv).content_views)["versions"]
      id = 0

      versions.each do |version|
        version.each do |k, v|
          if version["id"].to_f > id.to_f
            id = version["id"]
          end
        end
      end

      return id
    end

    # Find Puppet module ID from module name and version
    def find_puppet_module_id(name, version, repo_id)
      args = { "per_page" => "2000", "search" => name }
      pms = JSON.parse(SatellitePuppet::Repositories.new(repo_id).puppet_modules(args.to_json))["results"]

      list = {}
      pms.each do |pm|
        list[pm["id"]] = pm['version']
      end

      module_id = list.key(version)

      raise "ERROR:Puppet module ID not found, verify #{name} and #{version} are correct" if module_id.nil?

      return module_id
    end

    # Attach puppet module to CV if module is not already there,
    # or update CV with new module version
    def load_puppet_module_to_cv(name, version, id)
      pname = { "name" => name }
      cv = SatellitePuppet.sat_content_view

      # Find puppet module ID in CV
      pm_id = JSON.parse(SatellitePuppet::Content_view.new(cv).list_puppet_modules(pname.to_json))["results"]

      if pm_id.empty?
        puts "Attaching module to CV..."
        SatellitePuppet::Content_views.new(cv).content_view_puppet_modules(pname.to_json)
      else
        uuid = { "uuid" => id }
        my_id = ''
        pm_id.each do |pm|
          my_id = pm['id']
        end
        pname = pname.merge(uuid)
        puts "Updating existing puppet module in cv..."
        SatellitePuppet::Content_views.new(cv).update_puppet_module_in_cv(my_id, pname.to_json)
      end
    end

    def perform_incremental(description, module_id, env_id)

      content_view_version_id = find_cv_version_id.to_s
      params = { "description" => "#{description}",
                 "add_content" => { "puppet_module_ids" => ["#{module_id}"] },
                 "content_view_version_environments" => [{"environment_ids" => env_id,
                                                          "content_view_version_id" => "#{content_view_version_id}"]
      }
    end
  end
end








