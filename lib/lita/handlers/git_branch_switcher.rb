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
        response.reply(current_branch)
      end

      route(/^switch\s+(.+)/, command: true) do |response|
        branch_name = response.matches[0][0]

        g = Git.open(config.repository_path)
        g.fetch
        if g.is_branch?(branch_name)
          g.checkout(branch_name)
          g.pull(config.remote, branch_name) if config.pull_after_switch == true
          systemu(config.command_after_switch) unless config.command_after_switch.nil?
          response.reply(current_branch)
        else
          response.reply('[%{branch}] is not found.' % {branch: branch_name } )
        end
      end

      Lita.register_handler(self)
    end
  end
end
