classdef webRF < handle
   %webRF Class wrapper for the webRF PA.
   
   properties
      RMSin
      RMSout
      Idc
      Vdc
   end
   
   methods
      function obj = webRF()
         %webRF Construct an instance of this class
         obj.RMSin = -19;
      end
      
      function y = transmit(obj, x)
         [y, obj.RMSout, obj.Idc, obj.Vdc] = RFWebLab_PA_meas_v1_1(x, obj.RMSin); 
         
         
         % Need something to guarantee same as input length and aligned in TD.
         y = [y(5:end); 0; 0; 0; 0; 0];
         
         % Normalize
         y = y * norm(x) / norm(y);
      end
   end
end