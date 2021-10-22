require 'find'
require 'json'

class Danshari
  attr :home, true
  attr_reader :id

  def initialize(list)
    @home = ENV['HOME']
    @id = Time.now.strftime('%Y%m%d%H%M%S')
    @allfiles = []
    @allitems = []

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

  def exec
    puts @allfiles
    @allfiles.each { |file|
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

# # すべてファイルを処理
# #
# allfiles.each { |file|
#   upload_S3(file)
# }
# 
# puts "---"
# danshari_files.each { |file|
#   puts "mv #{file} dansharidir"
# }



