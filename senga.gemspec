Gem::Specification.new { |s|
	s.platform = Gem::Platform::RUBY

	s.author = "Pete Elmore"
	s.email = "pete@debu.gs"
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
