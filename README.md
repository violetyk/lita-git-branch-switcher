# lita-git-branch-switcher

git branch switcher

## Installation

Add lita-git-branch-switcher to your Lita instance's Gemfile:

``` ruby
gem "lita-git-branch-switcher"
```

## Configuration

in `lita_config.rb`

```ruby
Lita.configure do |config|
  # required
  config.handlers.git_branch_switcher.repository_path = "/path/to/repository"

  # options
  config.handlers.git_branch_switcher.pull_after_switch = true # default false
  config.handlers.git_branch_switcher.remote = 'github' # default origin
  config.handlers.git_branch_switcher.command_after_switch = %q(rake tmp:clear)
end
```

## Usage
- `current` show current branch name
- `switch <branch-name>` fetch and checkout a branch

```
> @bot current
BOT > master
YOU > @bot switch branch-name
BOT > branch-name
```
