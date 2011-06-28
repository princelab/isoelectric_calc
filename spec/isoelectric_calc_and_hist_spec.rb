require 'spec_helper'

describe "identify_potential_charges(str)" do
  it "identifies charges" do
		@test = 'AAAAAAAAAADYCEKHRST'
    result = identify_potential_charges(@test)
		result.y_num.should.equal 1
		result.hydrophobic_num.should.equal 10
		result.polar_num.should.equal 2
  end
end

describe 'charge at pH' do 
	before do 
		@test = 'AAAAAAAAAADYCEKHRST'
	end
	it 'gets the charge of a peptide right(pH 7)' do 
		charge_at_pH(identify_potential_charges(@test), 7).should.close( 0.027,0.001) 
	end
	it 'gets the charge of a peptide right(pH 4)' do 
		charge_at_pH(identify_potential_charges(@test), 4).should.close(1.96,0.01)
	end
	it 'gets the charge of a peptide right(pH 10)' do 
		charge_at_pH(identify_potential_charges(@test), 10).should.close(-2.38,0.01)
	end
end
describe 'pI calc' do 
	before do 
		@test = 'AAAAAAAAAADYCEKHRST'
	end
	it 'calculates the pI' do 
		calc_PI(identify_potential_charges(@test)).should.close(7.08,0.01)
	end
end
