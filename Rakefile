require 'rubygems/package_task'
require 'rdoc/task'

$: << "#{File.dirname(__FILE__)}/lib"

spec = eval File.read('senga.gemspec')

task :default => :package

Rake::RDocTask.new(:doc) { |t|
	t.main = 'doc/README'
	t.rdoc_files.include 'lib/**/*.rb', 'doc/*', 'bin/*', 'ext/**/*.c',
		'ext/**/*.rb'
	t.options << '-S' << '-N'
	t.rdoc_dir = 'doc/rdoc'
}

Gem::PackageTask.new(spec) { |pkg|
	pkg.need_tar_bz2 = true
}
desc "Cleans out the packaged files."
task(:clean) {
	FileUtils.rm_rf 'pkg'
}

desc "Builds and installs the gem for #{spec.name}"
task(:install => :package) {
	g = "pkg/#{spec.name}-#{spec.version}.gem"
	system "sudo gem install -l #{g}"
}

desc "Runs IRB, automatically require()ing #{spec.name}."
task(:irb) {
	exec "irb -Ilib -r#{spec.name}"
}
