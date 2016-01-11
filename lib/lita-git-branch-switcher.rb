require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/git_branch_switcher"

Lita::Handlers::GitBranchSwitcher.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
