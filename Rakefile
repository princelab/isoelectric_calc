# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "isoelectric_calc_and_hist"
  gem.homepage = "http://github.com/ryanmt/isoelectric_calc_and_hist"
  gem.license = "MIT"
  gem.summary = %Q{A pI calculator optimized for peptides which also features histogram graphing of the processed data.}
  gem.description = %Q{Implementation of a bisection pI calculator for Ruby.  Also included here is a graphing feature of a database via R.  The data accepted is a peptide centric database generated for the use of spectral counting (and available in the ms-quant gem)
http://isoelectric.ovh.org/files/practise-isoelectric-point.html#mozTocId496531
pK values utilized are from wikipedia for the 21-nth amino acids, while the primary 20 amino acid values come from Lehninger's Biochemistry text, edition 4.}
  gem.email = "ryanmt@byu.net"
  gem.authors = ["Ryan Taylor"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |spec|
  spec.libs << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
  spec.rcov_opts << '--exclude "gems/*"'
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "isoelectric_calc_and_hist #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
