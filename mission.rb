class Mission < ApplicationRecord
  validates :name, presence: true	
  validates :weight, presence: true
  validates :firstlocation, presence: true
  validate :secondcontrol, on: :create

  def secondcontrol
    errors.add(:secondlocation, "is can not same as firstlocation!") unless secondlocation != firstlocation
  end


  before_create :set_fuel



  def set_fuel
  	if self.secondlocation == "We don't have second location"
    	set_for_two_location
    else
    	set_for_three_location
    end
  end

  def set_for_two_location
  	set_gravity_for_two_location
 	  calculate_fuel_equipment_two_location
 	  calculate_fuels_fuel_two_location
  end


  def set_for_three_location
 	set_gravity_for_three_location
 	calculate_fuel_equipment_three_location
 	calculate_fuels_fuel_three_location
  end

  def set_gravity_for_two_location
  	if self.firstlocation =="Moon"
  		@@weight = self.weight
  		@@earth_gravity = 9.807
  		@@location1_gravity = 1.62
  	else
  		@@weight = self.weight
  		@@earth_gravity = 9.807
  		@@location1_gravity = 3.711
  	end
  end



  def set_gravity_for_three_location
  	if self.firstlocation =="Moon"
  		@@weight = self.weight
  		@@earth_gravity = 9.807
  		@@location1_gravity = 1.62
  		@@location2_gravity = 3.711
  	else
  		@@weight = self.weight
  		@@earth_gravity = 9.807
  		@@location2_gravity = 1.62
  		@@location1_gravity = 3.711
  	end
  end

  def calculate_fuel_equipment_two_location
  	@@fuel_equipment_two_location = (	((@@weight*@@earth_gravity*0.042 - 33).to_i) + 
			  							((@@weight*@@location1_gravity*0.033 - 42).to_i) + 
			  							((@@weight*@@location1_gravity*0.042 - 33).to_i) +
			  							((@@weight*@@earth_gravity*0.033 - 42).to_i) )
  end

  def calculate_fuel_equipment_three_location
  	@@fuel_equipment_three_location = (	(($weight*$earth_gravity*0.042 - 33).to_i) + 
			  							((@@weight*@@location1_gravity*0.033 - 42).to_i) +
			  							((@@weight*@@location1_gravity*0.042 - 33).to_i) +
			  							((@@weight*@@location2_gravity*0.033 - 42).to_i) +
			  							((@@weight*@@location2_gravity*0.042 - 33).to_i) +
			  							((@@weight*@@earth_gravity*0.033 - 42).to_i) )
  end

  def calculate_fuels_fuel_two_location
  	@nweight = @@fuel_equipment_two_location
  	@total_fuels_fuel = []
  	while ((@nweight*@@location1_gravity*0.033 - 42).to_i) > 0 
	  		@fuels_fuel = (	((@nweight*@@earth_gravity*0.042 - 33).to_i) + 
				  			((@nweight*@@location1_gravity*0.033 - 42).to_i) + 
				  			((@nweight*@@location1_gravity*0.042 - 33).to_i) +
				  			((@nweight*@@earth_gravity*0.033 - 42).to_i) )

	  	@@total_fuels_fuel.push(@fuels_fuel)
	  	@nweight = @fuels_fuel
  	end
  	self.fuel = @@total_fuels_fuel.sum + @@fuel_equipment_two_location
  end


  def calculate_fuels_fuel_three_location
  	$nweight = $fuel_equipment_three_location
  	$total_fuels_fuel = []

  	while (($nweight*$location1_gravity*0.033 - 42) && ($nweight*$location2_gravity*0.033 - 42))> 0
	  		$fuels_fuel = (($nweight*$earth_gravity*0.042 - 33) + 
				  			($nweight*$location1_gravity*0.033 - 42) + 
				  			($nweight*$location1_gravity*0.042 - 33) +
				  		  ($nweight*$location2_gravity*0.033 - 42) +
				  			($nweight*$location2_gravity*0.042 - 33) +
				  			($nweight*$earth_gravity*0.033 - 42) )

	  	$total_fuels_fuel.push($fuels_fuel)
      $nweight = $fuels_fuel
  	end
  	self.fuel = $total_fuels_fuel.sum + $fuel_equipment_three_location
  end
end
