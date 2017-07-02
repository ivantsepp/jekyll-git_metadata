require 'rbconfig'

module Jekyll
  module GitMetadata
    class Generator < Jekyll::Generator

      safe true

      def generate(site)
        raise "Git is not installed" unless git_installed?

        Dir.chdir(site.source) do
          data = load_git_metadata(site)
          site.config['git'] = data['site_data']
          jekyll_items(site).each do |page|
            if page.is_a?(Jekyll::Page)
              path = page.path
            else
              path = page.relative_path
            end
            page.data['git'] = data['pages_data'][path]
          end
        end
      end

      def load_git_metadata(site)

        current_sha = %x{ git rev-parse HEAD }.strip

        cache_dir = site.source + '/.git-metadata'
        FileUtils.mkdir_p(cache_dir) unless File.directory?(cache_dir)
        cache_file = cache_dir + "/#{current_sha}.json"

        if File.exist?(cache_file)
          return JSON.parse(IO.read(cache_file))
        end

        pages_data = {}
        jekyll_items(site).each do |page|
          if page.is_a?(Jekyll::Page)
            path = page.path
          else
            path = page.relative_path
          end
          pages_data[path] = page_data(path)
        end
        data = { 'site_data' => site_data, 'pages_data' => pages_data }

        File.open(cache_file, 'w') { |f| f.write(data.to_json) }

        data
      end

      def site_data
        {
          'project_name' => project_name,
          'files_count' => files_count,
        }.merge!(page_data)
      end

      def page_data(relative_path = nil)
        return if relative_path && !tracked_files.include?(relative_path)

        authors = self.authors(relative_path)
        lines = self.lines(relative_path)
        {
          'authors' => authors,
          'total_commits' => authors.inject(0) { |sum, h| sum += h['commits'] },
          'total_additions' => lines.inject(0) { |sum, h| sum += h['additions'] },
          'total_subtractions' => lines.inject(0) { |sum, h| sum += h['subtractions'] },
          'first_commit' => commit(lines.last['sha']),
          'last_commit' => commit(lines.first['sha'])
        }
      end

      def authors(file = nil)
        results = []
        cmd = 'git shortlog -se HEAD'
        cmd << " -- #{file}" if file
        result = %x{ #{cmd} }
        result.lines.each do |line|
          commits, name, email = line.scan(/(.*)\t(.*)<(.*)>/).first.map(&:strip)
          results << { 'commits' => commits.to_i, 'name' => name, 'email' => email }
        end
        results
      end

      def lines(file = nil)
        cmd = "git log --numstat --format=%h"
        cmd << " -- #{file}" if file
        result = %x{ #{cmd} }
        results = result.scan(/(.*)\n\n((?:.*\t.*\t.*\n)*)/)
        results.map do |line|
          files = line[1].scan(/(.*)\t(.*)\t(.*)\n/)
          line[1] = files.inject(0){|s,a| s+=a[0].to_i}
          line[2] = files.inject(0){|s,a| s+=a[1].to_i}
        end
        results.map do |line|
          { 'sha' => line[0], 'additions' => line[1], 'subtractions' => line[2] }
        end
      end

      def commit(sha)
        result = %x{ git show --format=fuller --name-only #{sha} }
        long_sha, author_name, author_email, author_date, commit_name, commit_email, commit_date, message, changed_files = result.scan(/commit (.*)\nAuthor:(.*)<(.*)>\nAuthorDate:(.*)\nCommit:(.*)<(.*)>\nCommitDate:(.*)\n\n((?:\s\s\s\s[^\r\n]*\n)*)\n(.*)/m).first.map(&:strip)
        {
          'short_sha' => sha,
          'long_sha' => long_sha,
          'author_name' => author_name,
          'author_email' => author_email,
          'author_date' => author_date,
          'commit_name' => commit_name,
          'commit_email' => commit_email,
          'commit_date' => commit_date,
          'message' => message.gsub(/    /, ''),
          'changed_files' => changed_files.split("\n")
        }
      end

      def tracked_files
        @tracked_files ||= %x{ git ls-tree --full-tree -r --name-only HEAD }.split("\n")
      end

      def project_name
        File.basename(%x{ git rev-parse --show-toplevel }.strip)
      end

      def files_count
        %x{ git ls-tree -r HEAD }.lines.count
      end

      def git_installed?
        null = RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'
        system "git --version >>#{null} 2>&1"
      end

      private

      def jekyll_items(site)
        site.pages + site.collections.values.map(&:docs).flatten
      end
    end
  end
end
