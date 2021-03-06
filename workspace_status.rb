#!/usr/bin/env ruby

# Doc ref: https://docs.bazel.build/versions/master/user-manual.html#flag--workspace_status_command.

git_branch = `git rev-parse --abbrev-ref HEAD`.strip!
git_commit_short = `git rev-parse --short --verify HEAD`.strip!

puts "STABLE_GIT_BRANCH #{git_branch}"
puts "STABLE_GIT_COMMIT_SHORT #{git_commit_short}"
