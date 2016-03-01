function [ c_f ] = cycles_to_failure( DOD )

% Calculates how many 

c_f = 15790*exp(-11.96*DOD)+2633*exp(-1.699*DOD);

end
