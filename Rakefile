
require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "aargvark"
  s.version = "0.0.15"
  s.author = "Mike Zazaian"
  s.email = "zazaian@gmail.com"
  s.homepage = "aargvark.rubyforge.org"
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = "aargvark"
  
  s.summary = "A simple, powerful argument parser for Ruby."
  s.description = <<-EOL
  A simple, powerful argument parser for Ruby
EOL
  
  s.files = %[ lib/aargvark.rb ]
  s.files =  Dir.glob("{lib}/**/**/*") + ["Rakefile"]
  s.rdoc_options << '--title' << 'Aargvark Documentation' <<
                       '--main'  << 'README' << '-q'
  s.require_path = "lib"
  s.has_rdoc = true
  s.extra_rdoc_files = %w[ README HISTORY LICENSE ]
end

desc "genrates documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README", "HISTORY", "LICENSE", "lib/" )
  rdoc.main     = "README"
  rdoc.rdoc_dir = "doc/html"
  rdoc.title    = "Aargvark Documentation"
end     
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
  pkg.need_zip = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "Generated #{spec.name}-#{spec.version}.gem (latest version) in ./pkg directory."
end

# EOF
