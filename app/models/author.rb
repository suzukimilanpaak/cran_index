class Author < Committer
  default_scope { where(type: :author) }
end
