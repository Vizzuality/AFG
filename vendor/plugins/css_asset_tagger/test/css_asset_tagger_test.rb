require 'test/unit'
require 'erb'
require 'rubygems'
require 'active_support'
require File.dirname(__FILE__)+'/../lib/css_asset_tagger_options'
require File.dirname(__FILE__)+'/../lib/css_asset_tagger'

class CssAssetTaggerTest < Test::Unit::TestCase
  ASSET_PATH = File.dirname(__FILE__)+'/assets'
  TEST_STYLESHEET = ASSET_PATH+'/stylesheets/test.css'

  def setup
    CssAssetTaggerOptions.asset_path = [ASSET_PATH]
    FileUtils.cp TEST_STYLESHEET+'.template', TEST_STYLESHEET
  end

  def teardown
    FileUtils.rm TEST_STYLESHEET
  end

  def test_this_plugin
    # TODO capture the warnings and test for them
    # how is this done?
    l = Logger.new STDOUT
    l.level = Logger::ERROR

    CssAssetTagger.tag [ASSET_PATH+'/stylesheets'], l

    # set the timestamps for the relative and absolute images
    abs_time = File.stat(ASSET_PATH+'/images/test.png').mtime.to_i
    rel_time = File.stat(ASSET_PATH+'/stylesheets/images/test.png').mtime.to_i
    
    assert_equal ERB.new(File.read(TEST_STYLESHEET+'.expected')).result(self.send(:binding)).to_s, File.read(TEST_STYLESHEET).to_s
  end
end
