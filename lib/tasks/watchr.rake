desc "Run watchr"
task watchr: :environment do
  sh %{bundle exec watchr .watchr}
end
