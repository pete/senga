require 'rake/gempackagetask'
require 'rake/rdoctask'

$: << "#{File.dirname(__FILE__)}/lib"

spec = Gem::Specification.new { |s|
	s.platform = Gem::Platform::RUBY

	s.author = "Pete Elmore"
	s.email = "1337p337@gmail.com"
	s.files = Dir["{lib,doc,bin,ext}/**/*"].delete_if {|f| 
		/\/rdoc(\/|$)/i.match f
	} + %w(Rakefile)
	s.require_path = 'lib'
	s.has_rdoc = true
	s.extra_rdoc_files = Dir['doc/*'].select(&File.method(:file?))
	s.extensions << 'ext/extconf.rb' if File.exist? 'ext/extconf.rb'
	Dir['bin/*'].map(&File.method(:basename)).map(&s.executables.method(:<<))

	s.name = 'senga'
	s.summary = "Senga draws lines.  Simplest graphing library."
	s.homepage = "http://github.com/pete/senga"
	%w(rmagick).each &s.method(:add_dependency)
	s.version = '0.1.0'
}

Rake::RDocTask.new(:doc) { |t|
	t.main = 'doc/README'
	t.rdoc_files.include 'lib/**/*.rb', 'doc/*', 'bin/*', 'ext/**/*.c', 
		'ext/**/*.rb'
	t.options << '-S' << '-N'
	t.rdoc_dir = 'doc/rdoc'
}

Rake::GemPackageTask.new(spec) { |pkg|
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

desc "Generates a static gemspec file; useful for github."
task(:static_gemspec) {
	# This whole thing is hacky.
	spec.validate
	spec_attrs = %w(
		platform author email files require_path has_rdoc extra_rdoc_files
		extensions executables name summary homepage
	).map { |attr|
		"\ts.#{attr} = #{spec.send(attr).inspect}\n"
	}.join << 
		"\ts.version = #{spec.version.to_s.inspect}\n" <<
		spec.dependencies.map { |dep|
			"\ts.add_dependency #{dep.name.inspect}, " \
				"#{dep.version_requirements.to_s.inspect}\n"
		}.join

	File.open("#{spec.name}.gemspec", 'w') { |f|
		f.print <<-EOGEMSPEC
# This is a static gempsec automatically generated by rake.  It's better to
# edit the Rakefile than this file.  It is kept in the repository for the
# benefit of github.

spec = Gem::Specification.new { |s|
#{spec_attrs}}

Gem::Builder.new(spec).build if __FILE__ == $0
		EOGEMSPEC
	}
}
