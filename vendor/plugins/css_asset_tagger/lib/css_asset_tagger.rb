class CssAssetTagger
  def self.tag(paths, logger = nil)
    logger ||= Logger.new($stderr)

    paths.each do |path|
      files = Dir.glob(File.join(path, '**/*.css'))
      for file in files
        css = File.read file
        res = css.gsub!(/url\((?:"([^"]*)"|'([^']*)'|([^)]*))\)/mi) do |s|
          # $1 is the double quoted string, $2 is single quoted, $3 is no quotes
          uri = ($1 || $2 || $3).to_s.strip

          # if the uri appears to begin with a protocol then the asset isn't on the local filesystem
          # or if query string appears to exist already, the uri is returned as is
          if uri =~ /[a-z]+:\/\//i || uri =~ /(\?|&)\d{10}/
            "url(#{uri})"
          else
            # if the first char is a / then get the path of the file with respect to the absolute path of the asset files
            # otherwise get the path relative to the current file
            path = (uri.first == '/' ? "#{CssAssetTaggerOptions.asset_path}#{uri}" : "#{File.dirname(file)}/#{uri}")

            begin
              # construct the uri with the associated asset query string
              sep = (uri =~ /\?/).nil? ? '?' : '&'
              "url(#{uri}#{sep}#{File.stat(path).mtime.to_i})"
            rescue Errno::ENOENT
              # the asset can't be found, so return the uri as is
              logger.warn "CssAssetTagger: #{path} referenced from #{file} cannot be found." if CssAssetTaggerOptions.show_warnings
              "url(#{uri})"
            end
          end
        end

        # write the new contents of the file out if asset tags were added
        File.open(file, 'w'){|f| f.puts css} unless res.nil?
      end
    end
  end
end
