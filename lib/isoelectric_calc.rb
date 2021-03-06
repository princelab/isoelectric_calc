#!/usr/bin/env ruby 
# http://isoelectric.ovh.org/files/practise-isoelectric-point.html#mozTocId496531

Precision = 0.001
ResidueTable = {
	:K => [2.18,8.95,10.53], 
	:E => [2.19,9.67,4.25], 
	:D => [1.88,9.60,3.65], 
	:H => [1.82,9.17,6.00],
	:R => [2.17,9.04,12.48],
	:Q => [2.17,9.13,nil],
	:N => [2.02,8.80,nil],
	:C => [1.96,10.28,8.18],
	:T => [2.11,9.62,nil],
	:S => [2.21,9.15,nil],
	:W => [2.38,9.39,nil],
	:Y => [2.20,9.11,10.07],
	:F => [1.83,9.13,nil],
	:M => [2.28,9.21,nil],
	:I => [2.36,9.68,nil],
	:L => [2.36,9.60,nil],
	:V => [2.32,9.62,nil],
	:P => [1.99,10.96,nil],
	:A => [2.34,9.69,nil],
	:G => [2.34,9.60,nil],
# These are the fringe cases... B and Z... Jerks, these are harder to calculate pIs
	:B => [1.95,9.20,3.65],
	:Z => [2.18,9.40,4.25],
	:X => [2.20,9.40,nil],
	:U => [1.96,10.28,5.20] # Unfortunately, I've only found the pKr for this... so I've used Cysteine's values.
}
PepCharges = Struct.new(:seq, :n_term, :c_term, :y_num, :c_num, :k_num, :h_num, :r_num, :d_num, :e_num, :u_num, :polar_num, :hydrophobic_num, :pi)
def identify_potential_charges(str)
	string = str.upcase
	first = string[0]; last = string[-1]
	puts string if first.nil? or last.nil?
	begin
		out = PepCharges.new(string, ResidueTable[first.to_sym][0], ResidueTable[last.to_sym][1], 0, 0, 0 ,0 ,0 ,0, 0, 0, 0, 0, 0)
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
			when "U"
				out.u_num += 1
			when "S", "T", "N", "Q"
				out.polar_num += 1
			when "A", "V", "I", "L", "M", "F", "W", "G", "P"
				out.hydrophobic_num += 1
		end
	end
	out
end # Returns the PepCharges structure

def charge_at_pH(pep_charges, pH)
	charge = 0
	charge += -1/(1+10**(pep_charges.c_term-pH))
	charge += -pep_charges.d_num/(1+10**(ResidueTable[:D][2]-pH))
	charge += -pep_charges.e_num/(1+10**(ResidueTable[:E][2]-pH))
	charge += -pep_charges.c_num/(1+10**(ResidueTable[:C][2]-pH))
	charge += -pep_charges.y_num/(1+10**(ResidueTable[:Y][2]-pH))
	charge += 1/(1+10**(pH - pep_charges.n_term))
	charge += pep_charges.h_num/(1+10**(pH-ResidueTable[:H][2]))
	charge += pep_charges.k_num/(1+10**(pH-ResidueTable[:K][2]))
	charge += pep_charges.r_num/(1+10**(pH-ResidueTable[:R][2]))
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

#require 'yaml'
#File.open('pi_list.yml', 'w') {|f| YAML.dump( pi, f) }
