require 'exifr/jpeg'
require 'find'
require 'json'
require 'digest/md5'
require 'gyazo'

class Danshari
  attr :home, true
  attr_reader :id

  def initialize(list)
    @home = ENV['HOME']
    @id = Time.now.strftime('%Y%m%d%H%M%S')
    @allfiles = []
    @allitems = []

    token = ENV['GYAZO_TOKEN'] # .bash_profileなどに書いてある
    @gyazo = Gyazo::Client.new access_token: token

    list.each { |item|
      if File.exist?(item)
        @allitems.push(item)
        if File.directory?(item)
          puts "file <#{item}> is directory"
        end
        Find.find(item) {|f|
          if File.file?(f)
            @allfiles.push f
          end
        }
      end
    }
  end

  def upload(file)
    STDERR.puts "ruby #{$home}/bin/upload #{file}"
    # s3url = `ruby #{home}/bin/upload #{file}`.chomp
    # STDERR.puts s3url
  end

  def modtime(file)
    time = File.mtime(file).strftime('%Y%m%d%H%M%S')
  end

  def getattr(file)
    attr = {}

    attr['filename'] = file

    # MD5値
    attr['md5'] = Digest::MD5.new.update(File.read(file)).to_s

    # 時刻
    attr['time'] = modtime(file)
    if file =~ /(\w+)\.(jpg|jpeg)/i
      begin
        exif = EXIFR::JPEG.new(file)
        t = exif.date_time
        if t
          attr['time'] = t.strftime("%Y%m%d%H%M%S")
        end
      rescue
      end
    end

    # サイズ
    attr['size'] = File.size(file)

    # convert -density 300 -geometry 1000 test.pdf[0] test1.jpg

    attr
  end

  def exec
    @allfiles.each { |file|
      attr = getattr(file)

      if file =~ /\.(jpg|jpeg|png)$/i
        attr['time'] =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/
        time = Time.local($1.to_i,$2.to_i,$3.to_i,$4.to_i,$5.to_i,$6.to_i)
        
        STDERR.puts "upload #{file} to Gyazo..."
        res = @gyazo.upload imagefile: file, created_at: time
        gyazourl = res[:permalink_url]

        attr['gyazourl'] = gyazourl
      elsif file =~ /\.pdf$/i
        attr['time'] =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/
        time = Time.local($1.to_i,$2.to_i,$3.to_i,$4.to_i,$5.to_i,$6.to_i)
        
        system "convert -density 300 -geometry 1000 '#{file}[0]' /tmp/danshari.jpg"
        
        STDERR.puts "upload /tmp/danshari to Gyazo..."
        res = @gyazo.upload imagefile: "/tmp/danshari.jpg", created_at: time
        gyazourl = res[:permalink_url]

        attr['gyazourl'] = gyazourl
      end

      puts attr

      upload(file)
    }
  end
end

if ARGV.length == 0
  STDERR.puts "% danshari files"
  exit
end

d = Danshari.new(ARGV)
d.exec

# puts "---"
# danshari_files.each { |file|
#   puts "mv #{file} dansharidir"
# }



