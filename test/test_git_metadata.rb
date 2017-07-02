require 'helper'

Minitest.after_run do
  remove_cache_dir
end

class Jekyll::GitMetadataTest < Minitest::Test
  context 'GitMetadata' do

    setup do
      create_temp_git_dir
      Jekyll.instance_variable_set(:@logger, Jekyll::LogAdapter.new(Jekyll::Stevenson.new, :error))

      config = Jekyll.configuration(
        :source => jekyll_test_repo_path,
        :destination => File.join(jekyll_test_repo_path, '_site'))
      @site = Jekyll::Site.new(config)
      @site.read
      @site.generate
    end

    teardown do
      remove_temp_git_dir
    end

    context 'site data' do
      setup do
        @site_data = @site.config['git']
      end

      should 'have correct project name' do
        assert_equal 'test_repo', @site_data['project_name']
      end

      should 'have correct files count' do
        assert_equal 14, @site_data['files_count']
      end

      should 'have correct totals count' do
        assert_equal 7, @site_data['total_commits']
        assert_equal 688, @site_data['total_additions']
        assert_equal 11, @site_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 3, @site_data['authors'].count
        assert @site_data['authors'].include?({"commits"=>5, "name"=>"Ivan Tse", "email"=>"ivan.tse1@gmail.com"})
        assert @site_data['authors'].include?({"commits"=>1, "name"=>"LeBron James", "email"=>"lbj@example.com"})
        assert @site_data['authors'].include?({"commits"=>1, "name"=>"Mark Morga", "email"=>"mmorga@rackspace.com"})
      end

      should 'have correct first commit data' do
        assert_equal '7884565', @site_data['first_commit']['short_sha']
        assert_equal '78845656f899d0bfd86d2806b85b0c54adddd3c8', @site_data['first_commit']['long_sha']
        assert_equal 'Ivan Tse', @site_data['first_commit']['author_name']
        assert_equal 'ivan.tse1@gmail.com', @site_data['first_commit']['author_email']
        assert_equal 'Mon Jul 14 02:01:29 2014 -0400', @site_data['first_commit']['author_date']
        assert_equal 'Ivan Tse', @site_data['first_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @site_data['first_commit']['commit_email']
        assert_equal 'Mon Jul 14 02:01:29 2014 -0400', @site_data['first_commit']['commit_date']
        assert_equal 'First commit with jekyll scaffold', @site_data['first_commit']['message']
      end

      should 'have correct last commit data' do
        assert_equal 'b8ffd38', @site_data['last_commit']['short_sha']
        assert_equal 'b8ffd38affdd1cc22ee4cb830cbe5c398b4e3df1', @site_data['last_commit']['long_sha']
        assert_equal 'Mark Morga', @site_data['last_commit']['author_name']
        assert_equal 'mmorga@rackspace.com', @site_data['last_commit']['author_email']
        assert_equal 'Tue Jun 20 11:36:43 2017 -0500', @site_data['last_commit']['author_date']
        assert_equal 'Mark Morga', @site_data['last_commit']['commit_name']
        assert_equal 'mmorga@rackspace.com', @site_data['last_commit']['commit_email']
        assert_equal 'Tue Jun 20 11:36:43 2017 -0500', @site_data['last_commit']['commit_date']
        assert_equal 'Adding example collection doc for git metadata', @site_data['last_commit']['message']
      end
    end

    context 'page data' do
      setup do
        @about_page = @site.pages.select{|p| p.name == 'about.md'}.first
        @page_data = @about_page.data['git']
      end

      should 'have correct totals count' do
        assert_equal 4, @page_data['total_commits']
        assert_equal 16, @page_data['total_additions']
        assert_equal 5, @page_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 2, @page_data['authors'].count
        assert @page_data['authors'].include?({"commits"=>3, "name"=>"Ivan Tse", "email"=>"ivan.tse1@gmail.com"})
        assert @page_data['authors'].include?({"commits"=>1, "name"=>"LeBron James", "email"=>"lbj@example.com"})
      end

      should 'have correct first commit data' do
        assert_equal '7884565', @page_data['first_commit']['short_sha']
        assert_equal '78845656f899d0bfd86d2806b85b0c54adddd3c8', @page_data['first_commit']['long_sha']
        assert_equal 'Ivan Tse', @page_data['first_commit']['author_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['first_commit']['author_email']
        assert_equal 'Mon Jul 14 02:01:29 2014 -0400', @page_data['first_commit']['author_date']
        assert_equal 'Ivan Tse', @page_data['first_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['first_commit']['commit_email']
        assert_equal 'Mon Jul 14 02:01:29 2014 -0400', @page_data['first_commit']['commit_date']
        assert_equal 'First commit with jekyll scaffold', @page_data['first_commit']['message']
      end

      should 'have correct last commit data' do
        assert_equal '70343eb', @page_data['last_commit']['short_sha']
        assert_equal '70343eb1287191b30371400048167253a883d6ca', @page_data['last_commit']['long_sha']
        assert_equal 'Ivan Tse', @page_data['last_commit']['author_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['author_email']
        assert_equal 'Sun Feb 12 02:21:26 2017 -0500', @page_data['last_commit']['author_date']
        assert_equal 'Ivan Tse', @page_data['last_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['commit_email']
        assert_equal 'Sun Feb 12 02:21:26 2017 -0500', @page_data['last_commit']['commit_date']
        assert_equal "This is a long commit message\n\nAs you can tell this commit message will span several lines long because\nI need to test long comit messages too!", @page_data['last_commit']['message']
        assert_equal ["_posts/2014-07-14-welcome-to-jekyll.markdown", "about.md"], @page_data['last_commit']['changed_files']
      end
    end

    context 'post data' do
      setup do
        @welcome_post = @site.posts.docs.select{|p| p.basename == '2014-07-14-welcome-to-jekyll.markdown'}.first
        @page_data = @welcome_post.data['git']
      end

      should 'have correct totals count' do
        assert_equal 3, @page_data['total_commits']
        assert_equal 30, @page_data['total_additions']
        assert_equal 0, @page_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 1, @page_data['authors'].count
        assert @page_data['authors'].include?({"commits"=>3, "name"=>"Ivan Tse", "email"=>"ivan.tse1@gmail.com"})
      end

      should 'have correct first commit data' do
        assert_equal '7884565', @page_data['first_commit']['short_sha']
        assert_equal '78845656f899d0bfd86d2806b85b0c54adddd3c8', @page_data['first_commit']['long_sha']
        assert_equal 'Ivan Tse', @page_data['first_commit']['author_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['first_commit']['author_email']
        assert_equal 'Mon Jul 14 02:01:29 2014 -0400', @page_data['first_commit']['author_date']
        assert_equal 'Ivan Tse', @page_data['first_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['first_commit']['commit_email']
        assert_equal 'Mon Jul 14 02:01:29 2014 -0400', @page_data['first_commit']['commit_date']
        assert_equal 'First commit with jekyll scaffold', @page_data['first_commit']['message']
      end

      should 'have correct last commit data' do
        assert_equal '70343eb', @page_data['last_commit']['short_sha']
        assert_equal '70343eb1287191b30371400048167253a883d6ca', @page_data['last_commit']['long_sha']
        assert_equal 'Ivan Tse', @page_data['last_commit']['author_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['author_email']
        assert_equal 'Sun Feb 12 02:21:26 2017 -0500', @page_data['last_commit']['author_date']
        assert_equal 'Ivan Tse', @page_data['last_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['commit_email']
        assert_equal 'Sun Feb 12 02:21:26 2017 -0500', @page_data['last_commit']['commit_date']
        assert_equal "This is a long commit message\n\nAs you can tell this commit message will span several lines long because\nI need to test long comit messages too!", @page_data['last_commit']['message']
        assert_equal ["_posts/2014-07-14-welcome-to-jekyll.markdown", "about.md"], @page_data['last_commit']['changed_files']
      end
    end

    context 'untracked file' do
      setup do
        @site.reset
        @untracked_file = File.join(jekyll_test_repo_path, 'untracked_file.html')
        File.open(@untracked_file, 'w') do |f|
          f.write("---\n---")
        end
        @site.read
        @untracked_page = @site.pages.select{|p| p.name == 'untracked_file.html'}.first
        @site.generate
      end

      teardown do
        File.delete(@untracked_file)
      end

      should 'not have git data' do
        assert_nil @untracked_page.data['git']
      end
    end

    context 'collection doc data' do
      setup do
        @gizmo_page = @site.collections['gizmos'].docs.select{|p| p.relative_path == '_gizmos/yoyo.md'}.first
        @page_data = @gizmo_page.data['git']
      end

      should 'have correct totals count' do
        assert_equal 1, @page_data['total_commits']
        assert_equal 9, @page_data['total_additions']
        assert_equal 0, @page_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 1, @page_data['authors'].count
        assert @page_data['authors'].include?({"commits"=>1, "name"=>"Mark Morga", "email"=>"mmorga@rackspace.com"})
      end

      should 'have correct first commit data' do
        assert_equal 'b8ffd38', @page_data['first_commit']['short_sha']
        assert_equal 'b8ffd38affdd1cc22ee4cb830cbe5c398b4e3df1', @page_data['first_commit']['long_sha']
        assert_equal 'Mark Morga', @page_data['first_commit']['author_name']
        assert_equal 'mmorga@rackspace.com', @page_data['first_commit']['author_email']
        assert_equal 'Tue Jun 20 11:36:43 2017 -0500', @page_data['first_commit']['author_date']
        assert_equal 'Mark Morga', @page_data['first_commit']['commit_name']
        assert_equal 'mmorga@rackspace.com', @page_data['first_commit']['commit_email']
        assert_equal 'Tue Jun 20 11:36:43 2017 -0500', @page_data['first_commit']['commit_date']
        assert_equal 'Adding example collection doc for git metadata', @page_data['first_commit']['message']
      end

      should 'have correct last commit data' do
        assert_equal 'b8ffd38', @page_data['last_commit']['short_sha']
        assert_equal 'b8ffd38affdd1cc22ee4cb830cbe5c398b4e3df1', @page_data['last_commit']['long_sha']
        assert_equal 'Mark Morga', @page_data['last_commit']['author_name']
        assert_equal 'mmorga@rackspace.com', @page_data['last_commit']['author_email']
        assert_equal 'Tue Jun 20 11:36:43 2017 -0500', @page_data['last_commit']['author_date']
        assert_equal 'Mark Morga', @page_data['last_commit']['commit_name']
        assert_equal 'mmorga@rackspace.com', @page_data['last_commit']['commit_email']
        assert_equal 'Tue Jun 20 11:36:43 2017 -0500', @page_data['last_commit']['commit_date']
        assert_equal 'Adding example collection doc for git metadata', @page_data['last_commit']['message']
      end
    end
  end
end
