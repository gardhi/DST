


% Loading input data
% InputData = SimulationInputData('LoadCurve_normalized_single_3percent_100.mat',...
%                                 'solar_data_Phuntsholing_baseline.mat',...
%                                 'surface_temp_phuent_2004_hour.mat');
% 
% 

% cyclesToFailure = zeros(1,100);
% % Initializing cycles to failure array: for every depth of discharge there
% % is a maximum number of partial cycles available.
% for dod = 0:100
%     cyclesToFailure(dod+1) = cycles_to_failure(dod/100);
% end
% 
% dod = 0:100;
% plot(cyclesToFailure,dod)

% A = [1 2 3 4;5 6 7 8;9 10 11 12]
% a = [2 3]';
% b = [2 2]';
% disp(diag(A(a,b)))

z = [1 2 3 0 0 0 4 5 6 7 0 0 8 9 10]'
find(z)