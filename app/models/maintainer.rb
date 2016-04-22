class Maintainer < Committer
  default_scope { where(type: :maintainer) }
end
