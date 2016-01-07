module SatellitePuppet
  class Repositories < SatellitePuppet::Base

    DEFINED_METHODS = {
      'content_uploads' => { :http_method => :post, :url_method_name => "content_uploads" },
      'import_uploads'  => { :http_method => :put, :url_method_name => "import_uploads" }
    }

    def uploads(content = nil, author, upload_id)
      #TODO: make it better
      regex = /^#{author}-#{content}-.*\.tar\.gz$/
      pkg = File.expand_path("pkg")
      f = Dir.new(pkg).select{|f| f.match(regex)}.last
      raise Errno::ENOENT, "File not found in #{pkg} with regex #{regex}" if f.nil?
      content = File.join(pkg, f)

      http_method = :put
      offset      = 0
      read_file = File.new(content, 'rb')
      @CONTENT_CHUNK_SIZE=1_000_000

      url =  base_url
      url += "/#{sat_resource_name}"
      url += "/content_uploads/"
      url += "#{upload_id}"

      puts "Staring Upload..!!"

      while (c = read_file.read(@CONTENT_CHUNK_SIZE))
        args = { :offset => "#{offset}", :content => "#{c}" }
        call_rest_method('upload', url, http_method, args)
        offset += @CONTENT_CHUNK_SIZE
      end
      read_file.close
    end 

    def delete(delete_id)
      http_method = :delete
      url = base_url
      url += "/#{sat_resource_name}"
      url += "/content_uploads/"
      url += "#{delete_id}"

      call_rest_method('delete_id', url, http_method, args = nil)
      puts "SUCCESS..!!"
    end
  end
end

