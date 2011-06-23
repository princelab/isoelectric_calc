PepID = Struct.new(:aaseq, :charge, :scan_num, :time)

def parse_pepxml(file)
	require 'nokogiri'	# This is from the run_compare code I wrote
	doc = Nokogiri.XML(File.open(file))
	pepids = []
	doc.xpath('//xmlns:spectrum_query').each do |spec_query|
		next if spec_query.to_s[/hit_rank="(1)"/, 1] != "1"
		output = PepID.new()
		output.scan_num = spec_query.to_s[/scans:(\d*),/, 1].to_i
		output.charge = spec_query.to_s[/assumed_charge="(\d*)"/, 1]
		output.time = nil
		output.aaseq = spec_query.to_s[/peptide="([A-Z]*)"/, 1]
		pepids << output
	end
	pepids
end

def pepids_to_pIs(pepid_arr)
	require 'isoelectric_calc'
	pIs = pepid_arr.map do |pepid|
		calc_PI(identify_potential_charges(pepid.aaseq)) unless pepid.aaseq.nil?
	end
	pIs
end

def graph_pI_arr(pIs, filename)
	hash = {:pi => pIs}
	require 'rserve/simpler'
	robj = Rserve::Simpler.new
	robj.converse(pi_values: hash.to_dataframe)
	wd = robj.converse('getwd()')
	robj.converse do 
		%Q{
			library(Cairo)
			Cairo(file="/home/ryanmt/Dropbox/coding/pI_checker_#{filename}.svg', width=9.5, height=6.8, type='svg', units='in')
		}
	end
	robj.converse do 
		%Q{
			hist(pi_values$pi,xlim=c(2,13))
			dev.off()
		}
	end
end

ARGV.each do |file|
	graph_pI_arr(pepids_to_pIs(parse_pepxml(file)), File.basename(file).gsub(File.extname(file),''))
end
		
