#!/usr/bin/env ruby 

require 'yaml'
require 'rserve/simpler'
pi_values = YAML.load_file(ARGV.shift)
p pi_values.class
p pi_values.first
hash = {}
hash['pi'] = []
hash['pi'] = pi_values

robject = Rserve::Simpler.new

robject.converse( pi_values: hash.to_dataframe) do 
	"attach(pi_values)"
end
robject.converse do 
	%Q{png(file='/home/ryanmt/Dropbox/coding/isoelectic_calc_and_hist/hist.png')
		hist(pi_values$pi, ylab="Counts", xlab="pI Values in pH units", main="Histogram of pI values for the ____ Database")
		dev.off()
	}
end
