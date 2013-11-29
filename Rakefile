task :default => [:install_submodules, :link, :install_vundles]
task :update => [:update_submodules, :link, :update_vundles]

task :install_submodules do
  sh "git submodule update --init"
end

task :update_submodules do
  sh "git submodule foreach git pull origin master"
end

task :install_vundles do
  sh "vim +BundleInstall +qall"
end

task :update_vundles do
  sh "vim +BundleInstall! +qall"
end

task :link do
  system_directories.each do |system_directory|
    each_system_file(system_directory) do |dot_file, system_file|
      puts "#{dot_file} => #{system_file}"
      make_directory(File.dirname(dot_file))
      link_file(system_file, dot_file)
    end
  end

  sh "mv ~/.zsh/completion/.git ~/.zsh/completion/_git"
end

def system_directories
  [ 'system' ]
end

def each_system_file(system_dir)
  return unless File.exist?(system_dir)

  Dir.glob("#{system_dir}/**/**") do |systemfile|
    next unless File.file?(systemfile) || File.symlink?(systemfile)

    relative_file = without_directory(systemfile, system_dir)
    dotfile = home_path(dotify(relative_file))
    systemfile = expanded_path(systemfile)

    yield dotfile, systemfile
  end
end

def without_directory(file, dir)
  file =~ /^#{dir}\/(.*)$/ && $1
end

def dotify(path)
  File.join path.split(File::SEPARATOR).map{ |s| s.sub(/^_/, '.') }
end

def expanded_path(path)
  File.expand_path(path, File.dirname(__FILE__))
end

def home_path(path)
  File.join ENV['HOME'], path
end

def make_directory(dir)
  mkdir_p(dir) unless exists_or_symlinked?(dir)
end

def link_file(src, dest)
  if exists_or_symlinked?(dest)
    warn "#{dest} already exists" unless links_to?(dest, src)
  else
    ln_s src, dest
  end
end

def links_to?(dest, src)
  File.symlink?(dest) && File.readlink(dest) == src
end

def exists_or_symlinked?(path)
  File.exist?(path) || File.symlink?(path)
end
