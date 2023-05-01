classdef Formulation < creatSystem
    methods
        function [obj,V,dV] = Formulation(params,formtype)
            obj = obj@creatSystem(params);
            if strcmp(formtype,'SOS')
                [V,dV] = sosFormulater(obj);
            elseif strcmp(formtype,'CCP')
                [V,dV] = ccpFormulater(obj);
            elseif strcmp(formtype,'DRCCP')
                [V,dV] = drccpFormulater(obj);
            else
                error('Formulation Type NOT Acceptable')
            end
        end
    end
end