classdef SimulationInputData
    %INPUTDATA Takes the filenames of the variables to use as properties,
    %and automatically loads the input data in the database folder.
    %   The point in this is that the expansion of functionality will be
    %   easier to read and more fool-proof.

    properties
        load
        irradiation
        temperature
        
        nHours
        nYears
        
        irradiationFilename
        loadProfileFilename
        temperatureFilename
        
        folderName
        databasePath
        
    end
    
    methods
        
        function obj = SimulationInputData(loadProfileFilename,...
                                           irradiationFilename,...
                                           temperatureFilename,...
                                           folderName)
            obj.folderName = folderName;
            obj.databasePath = get_path(folderName);
                                             
            obj.loadProfileFilename = loadProfileFilename;
            obj.irradiationFilename = irradiationFilename;
            obj.temperatureFilename = temperatureFilename;
                                             
            obj.load = importdata([obj.databasePath...
                                   obj.loadProfileFilename]); 
                               
            obj.irradiation = importdata([obj.databasePath...
                                          obj.irradiationFilename]);
                                      
            obj.temperature = importdata([obj.databasePath...
                                          obj.temperatureFilename]);
            
            if (length(obj.load) == length(obj.irradiation))...
            && (length(obj.load) == length(obj.temperature))
                obj.nHours = length(obj.temperature);
            else
                fprintf(['Warning: the data sets\n\t- irradiation data\n\t-',...
                         'ambience temperature data\n\t- load profile data \n',...
                         'are NOT the same size'])
            end
            
            obj.nYears = obj.nHours / 8760;
            
        end

    end
    
end

