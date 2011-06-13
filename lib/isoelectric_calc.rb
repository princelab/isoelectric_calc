#!/usr/bin/env ruby 
# http://isoelectric.ovh.org/files/practise-isoelectric-point.html#mozTocId496531

require 'yaml'
require 'lookup_table'
Precision = 0.001

PepCharges = Struct.new(:seq, :n_term, :c_term, :y_num, :c_num, :k_num, :h_num, :r_num, :d_num, :e_num, :pi)
def identify_potential_charges(str)
	string = str.upcase
	first = string[0]; last = string[-1]
	puts string if first.nil? or last.nil?
	begin
		out = PepCharges.new(string, Table[first.to_sym][0], Table[last.to_sym][1], 0, 0, 0 ,0 ,0 ,0, 0)
	rescue NoMethodError
		abort string
	end
	string.chars.each do |letter|
		case letter
			when "Y" 
				out.y_num += 1 
			when "C"
				out.c_num += 1
			when "K"
				out.k_num += 1 
			when "H"
				out.h_num += 1
			when "R"
				out.r_num += 1
			when "D"
				out.d_num += 1
			when "E"
				out.e_num += 1
		end
	end
	out
end # Returns the PepCharges structure

def charge_at_pH(pep_charges, pH)
	charge = 0
	charge += -1/(1+10**(pep_charges.c_term-pH))
	charge += -pep_charges.d_num/(1+10**(Table[:D][2]-pH))
	charge += -pep_charges.e_num/(1+10**(Table[:E][2]-pH))
	charge += -pep_charges.c_num/(1+10**(Table[:C][2]-pH))
	charge += -pep_charges.y_num/(1+10**(Table[:Y][2]-pH))
	charge += 1/(1+10**(pH - pep_charges.n_term))
	charge += pep_charges.h_num/(1+10**(pH-Table[:H][2]))
	charge += pep_charges.k_num/(1+10**(pH-Table[:K][2]))
	charge += pep_charges.r_num/(1+10**(pH-Table[:R][2]))
	charge
end


def calc_PI(pep_charges)
	pH = 8; pH_prev = 0.0; pH_next = 14.0
	charge = charge_at_pH(pep_charges, pH)
	while pH-pH_prev > Precision and pH_next-pH > Precision
		if charge < 0.0
			tmp = pH
			pH = pH - ((pH-pH_prev)/2)
			charge = charge_at_pH(pep_charges, pH)
			pH_next = tmp
		else
			tmp = pH
			pH = pH + ((pH_next - pH)/2)
			charge = charge_at_pH(pep_charges, pH)
			pH_prev = tmp
		end
	#	puts "charge: #{charge.round(2)}\tpH: #{pH.round(2)}\tpH_next: #{pH_next.round(2)}\tpH_prev: #{pH_prev.round(2)}"
	end
	pH
end
#pepcharges =[]
=begin
#  RUN the ENTRY FILE HERE
pi = []
io = File.open(ARGV.shift, 'r')
io.each_line do |line|
	pi << calc_PI(identify_potential_charges(line[/^([A-Z]+):.*/]))
end
=end
=begin
pIes = []
pepcharges.each do |a|
	pIes << [a, calc_PI(a)]
end
=end
#out_pi = pepcharges.map {|a| calc_PI(a)}


#File.open('pi_list.yml', 'w') {|f| YAML.dump( pi, f) }
