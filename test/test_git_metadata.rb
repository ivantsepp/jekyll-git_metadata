require 'helper'

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
        assert_equal 13, @site_data['files_count']
      end

      should 'have correct totals count' do
        assert_equal 5, @site_data['total_commits']
        assert_equal 670, @site_data['total_additions']
        assert_equal 11, @site_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 2, @site_data['authors'].count
        assert @site_data['authors'].include?({"commits"=>4, "name"=>"Ivan Tse", "email"=>"ivan.tse1@gmail.com"})
        assert @site_data['authors'].include?({"commits"=>1, "name"=>"LeBron James", "email"=>"lbj@example.com"})
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
        assert_equal '25d62f6', @site_data['last_commit']['short_sha']
        assert_equal '25d62f6feeb7190483f81564f4a76c1ec33d5118', @site_data['last_commit']['long_sha']
        assert_equal 'LeBron James', @site_data['last_commit']['author_name']
        assert_equal 'lbj@example.com', @site_data['last_commit']['author_email']
        assert_equal 'Mon Jul 14 02:12:31 2014 -0400', @site_data['last_commit']['author_date']
        assert_equal 'Ivan Tse', @site_data['last_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @site_data['last_commit']['commit_email']
        assert_equal 'Mon Jul 14 02:12:31 2014 -0400', @site_data['last_commit']['commit_date']
        assert_equal 'Be more friendly', @site_data['last_commit']['message']
      end
    end

    context 'page data' do
      setup do
        @about_page = @site.pages.select{|p| p.name == 'about.md'}.first
        @page_data = @about_page.data['git']
      end

      should 'have correct totals count' do
        assert_equal 3, @page_data['total_commits']
        assert_equal 14, @page_data['total_additions']
        assert_equal 5, @page_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 2, @page_data['authors'].count
        assert @page_data['authors'].include?({"commits"=>2, "name"=>"Ivan Tse", "email"=>"ivan.tse1@gmail.com"})
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
        assert_equal '25d62f6', @page_data['last_commit']['short_sha']
        assert_equal '25d62f6feeb7190483f81564f4a76c1ec33d5118', @page_data['last_commit']['long_sha']
        assert_equal 'LeBron James', @page_data['last_commit']['author_name']
        assert_equal 'lbj@example.com', @page_data['last_commit']['author_email']
        assert_equal 'Mon Jul 14 02:12:31 2014 -0400', @page_data['last_commit']['author_date']
        assert_equal 'Ivan Tse', @page_data['last_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['commit_email']
        assert_equal 'Mon Jul 14 02:12:31 2014 -0400', @page_data['last_commit']['commit_date']
        assert_equal 'Be more friendly', @page_data['last_commit']['message']
      end
    end

    context 'post data' do
      setup do
        @welcome_post = @site.posts.docs.select{|p| p.basename == '2014-07-14-welcome-to-jekyll.markdown'}.first
        @page_data = @welcome_post.data['git']
      end

      should 'have correct totals count' do
        assert_equal 2, @page_data['total_commits']
        assert_equal 28, @page_data['total_additions']
        assert_equal 0, @page_data['total_subtractions']
      end

      should 'have correct authors data' do
        assert_equal 1, @page_data['authors'].count
        assert @page_data['authors'].include?({"commits"=>2, "name"=>"Ivan Tse", "email"=>"ivan.tse1@gmail.com"})
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
        assert_equal '8365a44', @page_data['last_commit']['short_sha']
        assert_equal '8365a44c640d5c7cafc8788607a274dfd91b89bb', @page_data['last_commit']['long_sha']
        assert_equal 'Ivan Tse', @page_data['last_commit']['author_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['author_email']
        assert_equal 'Mon Jul 14 02:10:03 2014 -0400', @page_data['last_commit']['author_date']
        assert_equal 'Ivan Tse', @page_data['last_commit']['commit_name']
        assert_equal 'ivan.tse1@gmail.com', @page_data['last_commit']['commit_email']
        assert_equal 'Mon Jul 14 02:10:03 2014 -0400', @page_data['last_commit']['commit_date']
        assert_equal 'Edit first post', @page_data['last_commit']['message']
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

  end
end
