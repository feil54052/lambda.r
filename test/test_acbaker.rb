require 'minitest/autorun'
require 'acbaker'

class AcbakerTest < Minitest::Test

  def test_initialize
    FileUtils.mkdir("tmp") if not File.directory?("tmp")
    asset_pack = Acbaker::AssetPack.new(:AppIcon)
    assert_equal :AppIcon, asset_pack.type
  end
  
  def test_appicon
    FileUtils.mkdir_p("tmp/AppIcon.appiconset") if not File.directory?("tmp/AppIcon.appiconset")
    asset_pack = Acbaker::AssetPack.new(:AppIcon)
    asset_pack.process("test/assets/AppIcon.png", "tmp/AppIcon.appiconset")
  end

  def test_launchimage
    FileUtils.mkdir_p("tmp/LaunchImage.launchimage") if not File.directory?("tmp/LaunchImage.launchimage")
    asset_pack = Acbaker::AssetPack.new(:LaunchImage)
    asset_pack.process("test/assets/LaunchImage.png", "tmp/LaunchImage.launchimage")
  end

end