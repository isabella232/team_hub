# team_hub - Components for creating a team Hub using Jekyll
#
# Written in 2015 by Mike Bland (michael.bland@gsa.gov)
# on behalf of the 18F team, part of the US General Services Administration:
# https://18f.gsa.gov/
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
#
# @author Mike Bland (michael.bland@gsa.gov)

require_relative "test_helper"
require_relative "../lib/team_hub/private_assets"
require_relative "site"

require "minitest/autorun"
require "test_temp_file_helper"

module TeamHub
  class PrivateAssetsExistsTest < ::Minitest::Test
    def setup
      @temp_file_helper = TestTempFileHelper::TempFileHelper.new
      config = {
        'source' => @temp_file_helper.tmpdir,
        'private_data_path' => 'private_assets',
      }
      @site = DummyTestSite.new(config: config)
      @testdir = File.join config['source'], config['private_data_path']
      @temp_file_helper.mkdir @site.config['private_data_path']
    end

    def teardown
      @temp_file_helper.teardown
    end

    def mkfile(relative_path)
      @temp_file_helper.mkfile(
        File.join @site.config['private_data_path'], relative_path)
      relative_path
    end

    def test_nonexistent_file
      refute PrivateAssets.exists? @site, 'nonexistent_file'
    end

    def test_file_exists
      relative_path = mkfile File.join('this', 'file', 'exists')
      assert(PrivateAssets.exists?(@site, relative_path),
        "Didn't find: #{relative_path}")
    end
  end
end
