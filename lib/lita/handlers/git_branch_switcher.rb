require 'git'
require 'systemu'

module Lita
  module Handlers
    class GitBranchSwitcher < Handler
      config :repository_path
      config :remote, default: 'origin'
      config :pull_after_switch, default: false
      config :command_after_switch, default: nil

      def current_branch
        g = Git.open(config.repository_path)
        log = g.log.first
        "[%{branch}] %{date} %{author} %{message}" % {
          branch: g.current_branch,
          date: log.author.date,
          author: log.author.name,
          message: log.message.lines.first,
        }
      end

      route(/^current$/, command: true) do |response|
        response.reply("@%{user} %{branch}" % {
          user: response.user.mention_name,
          branch: current_branch,
        })
      end

      route(/^switch\s+(.+)/, command: true) do |response|
        begin
          branch_name = response.matches[0][0]

          g = Git.open(config.repository_path)
          g.fetch unless config.remote.nil?
          if g.is_branch?(branch_name)
            g.checkout(branch_name)
            g.pull(config.remote, branch_name) if !config.remote.nil? && config.pull_after_switch == true
            systemu(config.command_after_switch) unless config.command_after_switch.nil?
            response.reply("@%{user} %{branch}" % {
              user: response.user.mention_name,
              branch: current_branch,
            })
          else
            response.reply("@%{user} [%{branch}] is not found." % {
              user: response.user.mention_name,
              branch: branch_name
            })
          end
        rescue => e
          response.reply("@%{user} I was not able to do it. \n```\n%{message}\n```" % {
            user: response.user.mention_name,
            message: e.message,
          })
        end
      end

      Lita.register_handler(self)
    end
  end
end
