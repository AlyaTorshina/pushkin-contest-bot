task :drop do
  on roles(:all) do
    within current_path do
      execute :bundle, :exec, 'rails', 'db:drop', 'RAILS_ENV=production'
    end
  end
end
