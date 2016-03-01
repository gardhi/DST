

cyclesToFailure = zeros(1,101);
dod = 0:0.01:1;

for i = 1:length(dod)


    cyclesToFailure(i) = cycles_to_failure(dod(i));


end

% disp(cyclesToFailure)

%disp(-diff(dod*100)./diff(cyclesToFailure))

figure
plot(dod*100,cyclesToFailure)
