variables {
  force_delete = true
}

run "apply_github" {
  command = apply

  module {
    source = "./examples/github"
  }
}