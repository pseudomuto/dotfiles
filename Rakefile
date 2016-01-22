task default: [:install_submodules, :link, :install_vundles, :compile_command_t]
task update: [:update_submodules, :link, :update_vundles, :compile_command_t]

task :install_submodules do
  sh "git submodule update --init"
end

task :update_submodules do
  sh "git submodule foreach git pull origin master"
end

task :install_vundles do
  sh "vim -u #{ENV['HOME']}/.vim/Vundlefile.vim +PluginInstall +qall"
end

task :update_vundles do
  sh "vim -u #{ENV['HOME']}/.vim/Vundlefile.vim +PluginInstall! +qall"
end

task :compile_command_t do
  Dir.chdir("#{ENV["HOME"]}/.vim/bundle/command-t/ruby/command-t") do
    sh "ruby extconf.rb"
    sh "make"
  end
end

task :link do
  each_system_file("system") do |dot_file, system_file|
    `mkdir -p #{File.dirname(dot_file)}`
    ln_sf(system_file, dot_file)
  end

  sh "mv ~/.zsh/completion/.git ~/.zsh/completion/_git"
  sh "mv ~/.zsh/completion/.hub ~/.zsh/completion/_hub"
end

def each_system_file(system_dir)
  Dir.glob("#{system_dir}/**/**") do |file|
    next unless File.file?(file) || File.symlink?(file)

    relative_file = without_directory(file, system_dir)
    dotfile       = File.join(ENV["HOME"], dotify(relative_file))

    yield dotfile, File.expand_path(file, File.dirname(__FILE__))
  end
end

def without_directory(file, dir)
  file =~ /^#{dir}\/(.*)$/ && $1
end

def dotify(path)
  paths = path.split(File::SEPARATOR).map { |file_path| file_path.sub(/^_/, ".") }
  File.join(paths)
end
