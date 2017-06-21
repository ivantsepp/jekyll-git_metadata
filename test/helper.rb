require 'minitest/autorun'
require 'minitest/unit'
require 'shoulda'
require 'mocha/mini_test'
require 'jekyll'
require 'jekyll-git_metadata'

def jekyll_test_repo_path
  File.join(File.dirname(__FILE__), 'test_repo')
end

def remove_cache_dir
  FileUtils.rm_rf(File.join(jekyll_test_repo_path, '.git-metadata'))
end

class Minitest::Test
  def dot_git_path
    File.join(jekyll_test_repo_path, 'dot_git')
  end

  def real_dot_git_path
    File.join(jekyll_test_repo_path, '.git')
  end

  def create_temp_git_dir
    FileUtils.cp_r(dot_git_path, real_dot_git_path)
  end

  def remove_temp_git_dir
    FileUtils.rm_rf(real_dot_git_path)
  end
end
