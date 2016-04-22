function [LowestIrradiation, LargestLoadProfile, LargestLossOfLoad]...
                     = get_worst_case_periods(load,irradiation,lossOfLoad)
        % Outputs have properties of both day and week, and those have both
        % value and time properties, this way you can know the value of the
        % worst day, and when it occurs etc.
        
        % for termination before algorithm exceeds index
        hourLastWeekStart = length(load) - 24*7;
        hoursInWeek = 24*7;

        % initiations
        [LowestIrradiation.Day.value, LowestIrradiation.Week.value]...
                                                        = deal(inf);
        [LargestLoadProfile.Day.value, LargestLoadProfile.Week.value,...
         LargestLossOfLoad.Day.value, LargestLossOfLoad.Week.value]...
                                                        = deal(0);

        for i = 1:24:(length(load)-24)

            % calculate values for the days
            irradiationToday = sum(irradiation(i:i+23));
            loadProfileToday = sum(load(i:i+23));
            lossOfLoadToday = sum(lossOfLoad(i:i+23));

            % if we break any records for worst case day, we save it
            if  irradiationToday < LowestIrradiation.Day.value
                LowestIrradiation.Day.time = i;
                LowestIrradiation.Day.value = irradiationToday;
            end

            if loadProfileToday > LargestLoadProfile.Day.value
                LargestLoadProfile.Day.time = i;
                LargestLoadProfile.Day.value = loadProfileToday;
            end

            if lossOfLoadToday > LargestLossOfLoad.Day.value
                LargestLossOfLoad.Day.time = i;
                LargestLossOfLoad.Day.value = lossOfLoadToday;
            end

            % if there is a new week
            if i < hourLastWeekStart
                
                % calculate values for the week
                irradiationThisWeek = ...
                    sum(irradiation(i:(i + hoursInWeek - 1)));
                loadProfileThisWeek =...
                    sum(load(i:(i + hoursInWeek - 1)));
                lossOfLoadThisWeek =...
                    sum(lossOfLoad(i:(i + hoursInWeek - 1)));

                % if we break any records for worst case week, we save it
                if  irradiationThisWeek < LowestIrradiation.Week.value
                    LowestIrradiation.Week.time = i;
                    LowestIrradiation.Week.value = irradiationThisWeek;
                end

                if  loadProfileThisWeek > LargestLoadProfile.Week.value
                    LargestLoadProfile.Week.time = i;
                    LargestLoadProfile.Week.value = loadProfileThisWeek;
                end

                if  lossOfLoadThisWeek > LargestLossOfLoad.Week.value
                    LargestLossOfLoad.Week.time = i;
                    LargestLossOfLoad.Week.value = lossOfLoadThisWeek;
                end                    

            end

        end



end