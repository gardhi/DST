classdef TestClass
   
   properties (SetAccess = protected)
       inn1
       inn2
   end
    
   properties (Dependent)
      dependentVar
   end
   
   
   methods
   
       function obj = TestClass(inn1,inn2)
           obj.inn1 = inn1;
           obj.inn2 = inn2;
       end
       function data = get.dependentVar(obj)
          data = obj.inn1 + obj.inn2;
       end
    function out1 = output(obj, inn3)

        out1 = obj.inn1 + inn3;

    end
      
   end
end