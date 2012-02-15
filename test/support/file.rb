require 'fileutils'

module TestHelpers
  class FileBuilder
    attr_reader :path, :files

    def initialize(context, path)
      @context   = context
      @path      = path
      @files     = {}
      @directory = []
      @common    = {}

      FileUtils.rm_rf(@path)

      @common[:hello_html] = <<-HTML
<html>
<head>
  <title>Hello world</title>
</head>
<body>
  <p>Hello all</p>
</body>
</html>
      HTML

      @common[:hello_js] = <<-JS
$(function(){
  alert('zomg');
});
      JS

      @common[:abc_html] = <<-HTML
<html>
<head>
  <title>abc</title>
</head>
<body>
  <p>HELLO, WORLD</p>
</body>
</html>
      HTML

      @common[:config] = <<-CONFIG
sm_app_name: testapp
sm_client_name: testclient
html5: true

development:    
  key: 65628134-b512-43bf-a28f-926008964360
  secret: da5a274e-7c01-4855-ac49-2351fe42dbda
    CONFIG

    end

    def directory(dir)
      @directory.push dir
      yield
    ensure
      @directory.pop
    end

    def file(path, content)
      if Symbol === content
        content = @common[content]
      end

      fullpath = @path.join(*@directory).join(path)

      FileUtils.mkdir_p fullpath.dirname
      File.open(fullpath, 'w') do |f|
        f.write content
      end

      @files[path] = content
    end

    def delete(path)
      @files.keys.each do |p|
        @files.delete(p) if p =~ /^#{Regexp.escape(p)}(\/|$)/
      end

      FileUtils.rm_rf @path.join(path)
    end

    def [](key)
      case key
      when Symbol then @common[key]
      else             @files[key]
      end
    end

    def gitify!
      FileUtils.cp_r @context.fixtures('git-dir'), "#{path}/.git"
    end

    def git(cmd)
      Dir.chdir path do
        system "git #{cmd}"
      end
    end
  end

  def write_files(path = local)
    files = FileBuilder.new(self, path)
    yield files
    files
  end
end
