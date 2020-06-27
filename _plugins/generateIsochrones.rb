require 'open-uri'

module Jekyll
  class IsochroneGenerator < Generator
    safe true

    def generate(site)
      if site.config['isochrone_dataset']
        puts "Generate the isochrones"
        site.data[site.config['isochrone_dataset']].each_index do |sf|
          if site.data[site.config['isochrone_dataset']][sf]['lat'] == 0 && site.data[site.config['isochrone_dataset']][sf]['lon'] == 0
            puts "Skipping null island "+site.data[site.config['isochrone_dataset']][sf]['name']
          else
            area = site.data[site.config['isochrone_dataset']][sf]
            puts area['name']
            [
              # Adding wheelchair=yes and walkSpeed=SOMETHING m/s to this will give a reduced mobility option (WALK defaults to a walkSpeed that's ~3mph)
              { 'prefix': 'reduced', 'mode': 'WALK', 'extraParams': '&wheelchair=yes&walkSpeed=0.9' },
              { 'prefix': 'walk', 'mode': 'WALK', 'extraParams': '' },
              { 'prefix': 'bicycle', 'mode': 'BICYCLE', 'extraParams': '' }
            ].each do |transport|
puts transport
puts transport[:prefix]
              #isourl = "http://trips.mcqn.com:8080/otp/routers/default/isochrone?fromPlace=#{area['lat']},#{area['lon']}&mode=#{transport}&cutoffSec=300&cutoffSec=600&cutoffSec=900"
              isourl = "http://trips.mcqn.com:8080/otp/routers/default/isochrone?fromPlace=#{area['lat']},#{area['lon']}&mode=#{transport[:mode]}&cutoffSec=900#{transport[:extraParams]}"
              isochrone = URI.open(isourl).read
              isofile = IsochroneFile.new(site, site.source, "isochrones", "#{site.data[site.config['isochrone_dataset']][sf]['name']}-#{transport[:prefix]}", isochrone)
              site.data[site.config['isochrone_dataset']][sf]["#{transport[:prefix]}url"] = isofile.url
              site.static_files << isofile
            end
          end
        end
      else
        puts "### Warning: Isochrone plugin included but 'isochrone_dataset' not configured in '_config.yml'"
      end
    end
  end

  class IsochroneFile < StaticFile
    def initialize(site, base, dir, name, content)
      @site = site
      @base = base
      @dir = dir
      @name = sanitize(name)+".geojson"
      @relative_path = File.join(*[@dir, @name].compact)
      @extname = File.extname(@name)
      @content = content
    end

    def sanitize(name)
      name.downcase.strip.gsub(' ', '-').gsub(/[^\w.-]/, '')
    end

    def write(dest)
      dest_path = destination(dest)
      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.rm(dest_path) if File.exists?(dest_path)
      File.open(dest_path, 'w') { |file| file.write(@content) }
      true
    end
  end

  class IsochronePage < Page
    # - site and base are copied from other plugins: to be honest, I am not sure what they do
    #
    # - `index_files` specifies if we want to generate named folders (true) or not (false)
    # - `dir` is the default output directory
    # - `data` is the data defined in `_data.yml` of the record for which we are generating a page
    # - `name` is the key in `data` which determines the output filename
    # - `name_expr` is an expression for generating the output filename
    # - `template` is the name of the template for generating the page
    # - `extension` is the extension for the generated file
    #def initialize(site, base, index_files, dir, data, name, name_expr, template, extension)
    def initialize(site, base, index_files, dir, data, name, name_expr, template, extension)
      @site = site
      @base = base
puts site

      # @dir is the directory where we want to output the page
      # @name is the name of the page to generate
      # @name_expr is an expression for generating the name of the page
      #
      # the value of these variables changes according to whether we
      # want to generate named folders or not
      #if name_expr
      #  record = data
      #  raw_filename = eval(name_expr)
      #  if raw_filename == nil
      #    puts "error (datapage_gen). name_expr '#{name_expr}' generated an empty value in record #{data}"
      #    return
      #  end
      #else
      #  raw_filename = data[name]
      #  if raw_filename == nil
      #    puts "error (datapage_gen). empty value for field '#{name}' in record #{data}"
      #    return
      #  end
      #end

      filename = "amc_test.geojson" #sanitize_filename(raw_filename).to_s

      @dir = dir + (index_files ? "/" + filename + "/" : "")
      @name = filename

      self.process(@name)
      #self.read_yaml(File.join(base, '_layouts'), template + ".html")
      self.data['title'] = raw_filename
      # add all the information defined in _data for the current record to the
      # current page (so that we can access it with liquid tags)

      if data.key?('name')
        data['_name'] = data['name']
      end

      self.data.merge!(data)
    end
  end
end
