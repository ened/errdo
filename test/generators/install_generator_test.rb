require 'test_helper'

class InstallGeneratorTest < Rails::Generators::TestCase

  tests Errdo::Generators::InstallGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination
  setup :make_application_rb
  setup :make_initializers_dir

  should "assert all files are properly created and exceptions app is set" do
    run_generator
    assert_file "config/initializers/errdo.rb"
    assert_file "config/application.rb", /(config.exceptions_app = Errdo::ExceptionsApp)/
  end

  private

  def make_application_rb
    mkdir "#{destination_root}/config/"
    File.open("#{destination_root}/config/application.rb", 'w') do |file|
      file.write("module Dummy\n  class Application\n  end\nend")
    end
  end

  def make_initializers_dir
    mkdir "#{destination_root}/config/initializers/"
  end

end
