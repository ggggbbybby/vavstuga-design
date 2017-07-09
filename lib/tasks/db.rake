namespace :db do
  task replace: [:drop, :create, :migrate, :seed]
end