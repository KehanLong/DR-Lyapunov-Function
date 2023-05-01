classdef Formulation < creatSystem
    methods
        function [obj,V] = Formulation(params,formtype)
            obj = obj@creatSystem(params);
            if strcmp(formtype,'SOS')
                V = sosFormulater(obj);
            elseif strcmp(formtype,'CCP')
                V = ccpFormulater(obj);
            elseif strcmp(formtype,'DRCCP')
                V = drccpFormulater(obj);
            else
                error('Formulation Type NOT Acceptable')
            end
        end
    end
end