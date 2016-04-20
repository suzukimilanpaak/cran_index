class Author < Committer
  default_scope { where(type: :maintainer) }
end
