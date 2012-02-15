require 'helper'

class RewriteTest < MiniTest::Unit::TestCase
  include TestHelpers

  def setup
    host! :local_server

    @start_dir = Dir.pwd
    launch_test_server

    @files = write_files do |b|
      b.file ".stackmob", :config
      b.file "index.html", :hello_html
      b.file "abc.html",  :abc_html
      b.file "foobar/index.html", :hello_html
      b.file "404.html", "missing page"
    end


    Dir.chdir local

    run_cli "server"
  end

  def teardown
    shutdown_test_server
    kill!
    Dir.chdir @start_dir
  end

  def test_serve
    get "/"
    assert_responds_with 200, @files[:hello_html]

    get "/index.html"
    assert_responds_with 200, @files[:hello_html]
    
    get "/abc.html"    
    assert_responds_with 200, @files[:abc_html]

    get "/foobar"
    assert_responds_with 200, @files[:hello_html]

    get "/foobar/index.html"
    assert_responds_with 200, @files[:hello_html]
  end

  def test_custom_404
    get "/dne"
    assert_responds_with 404, @files["404.html"]
  end

end

