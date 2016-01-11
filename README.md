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
  config.handlers.git_branch_switcher.repository_path = "/path/to/repository"
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
