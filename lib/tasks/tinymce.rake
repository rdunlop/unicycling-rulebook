namespace :tinymce do
  desc "Copy TinyMCE from node_modules to public/"
  task :copy do
    source = Rails.root.join("node_modules/tinymce")
    dest = Rails.root.join("public/tinymce")
    FileUtils.rm_rf(dest)
    FileUtils.cp_r(source, dest)
    puts "TinyMCE copied to public/tinymce"
  end
end
Rake::Task["assets:precompile"].enhance(["tinymce:copy"])
