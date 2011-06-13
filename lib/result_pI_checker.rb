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
	puts pepid.aaseq.inspect
		calc_PI(identify_potential_charges(pepid.aaseq)) unless pepid.aaseq.nil?
	end
	pIs
end

def graph_pI_arr(pIs, filename)
	hash = {:pi => pIs}
	require 'rserve/simpler'
	robj = Rserve::Simpler.new
	robj.converse(pi_values: hash.to_dataframe)
	p robj.converse("pi_values$pi")
	robj.converse do 
		%Q{
			#png(file='/home/ryanmt/Dropbox/coding/isoelectric_calc_and_hist/pI_checker_#{filename}.png')
			hist(pi_values$pi)
		}
	end
	robj.pause
end

ARGV.each do |file|
	graph_pI_arr(pepids_to_pIs(parse_pepxml(file)), "F002720")
end
		
