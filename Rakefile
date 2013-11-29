task :default => [:install_submodules, :link]

task :install_submodules do
  sh "git submodule update --init"
end

task :update_submodules do
  sh "git submodule foreach git pull origin master"
end

task :link do
  system_directories.each do |system_directory|
    each_system_file(system_directory) do |dot_file, system_file|
      puts "#{dot_file} => #{system_file}"
    end
  end
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
