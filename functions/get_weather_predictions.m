function weatherPredictions = get_weather_predictions(pvPowerAbsorbedKw,...
                                                      nomPeakPvPowerTreshold)

    weatherPredictions = cell(1,ceil(length(pvPowerAbsorbedKw)/24));
    globalPeakPowerAbsorbedKw = max(pvPowerAbsorbedKw);
    
    for t = 1: length(pvPowerAbsorbedKw)-24
        
        if mod(t,24)
            
            day = t/24;
            thisPeakPowerAbsorbedKw = max(pvPowerAbsorbedKw(t:t+24));
            
            % check weather the coming day has a relatively low power
            % absorbed, and assume that this can be predicted.
            if (thisPeakPowerAbsorbedKw/globalPeakPowerAbsorbedKw)...
            >  nomPeakPvPowerTreshold
        
                weatherPredictions{day} = 'sunny';
                
            else
                
                weatherPredictions{day} = 'cloudy';
        
            end

        end
        
    end


end