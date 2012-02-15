module TestHelpers
   def reset!
    Dir[ tmp('**/*') ].each do |file|
      next if file =~ /one-time/
      rm_rf file
    end

    [ home, local ].each do |dir|
      FileUtils.mkdir_p(dir)
    end
  end

  def cd(path, &blk)
    Dir.chdir(path, &blk)
  end

  def cwd(*args)
    Pathname.new(Dir.pwd).join(*args)
  end

  include FileUtils

  def root
    @root ||= Pathname.new(File.expand_path("../../..", __FILE__))
  end

  def fixtures(*path)
    root.join('spec/support/fixtures', *path)
  end

  def tmp(*path)
    root.join("tmp", *path)
  end

  def one_time(*path)
    tmp('one-time', *path)
  end

  def home(*path)
    tmp.join("home", *path)
  end

  def local(*path)
    tmp.join("local", *path)
  end

  def local2(*path)
    tmp.join("local2", *path)
  end

  module_function :root, :tmp, :home, :local
end
