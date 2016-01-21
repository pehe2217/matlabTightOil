function producer = producerStrategy(printProgress, producer,t)
% PRODUCER STRATEGY:
% Wells are drilled according to the producers strategy.
if(nargin<1)
    printProgress = false;
end

%global T economicDynamics
%global oilPrice

if(economicDynamics)
%     if(t>6)
%         meanPrice = mean(oilPrice((t-6):t));
%     elseif(t>3)
%         meanPrice = mean(oilPrice((t-3):t));
%     else
%         meanPrice = oilPrice(t);
%     end
    
    % [USD]:
    npv = NPVestimator(oilPrice(t),producer.NPVestimatorInput);
    if((mod(t,10) == 0) && printProgress)
        fprintf('Producer %0.0f: Inspection of well.\n',prod);
        fprintf('Estimated Net Present Value: %f \n',npv);
    end
end

switch producer.strategy
    case 'NPV'
        % npv > producer.NPVaggrConserv
        % DO NOT USE! 
        % No maximum availability of rigs. The producer will drill
        % unlimited number of wells! 
        % 
        while(npv > producer.NPVaggrConserv)
            producer = investInNewWell(producer,t);
        end
    case 'cash'
        % capital > drilling cost and completion cost
        %
        % NOTE: No maximum availability of rigs. The producer will drill
        % until its capital is finished.
        while(producer.capital(t) > (producer.NPVestimatorInput.drillCost+producer.NPVestimatorInput.comCost))
            producer = investInNewWell(producer,t);
        end
    case 'rig'
        % 
        availableRigs = producer.rigs(t) * producer.wellsPerRigRate(t);
        while(availableRigs>0)
            availableRigs = availableRigs -1;
            producer = investInNewWell(producer,t);
        end
    case 'NPV_cash'
        % npv > producer.NPVaggrConserv
        % capital > drilling cost and completion cost
        %
        % NOTE: no maximum availability of rigs. The producer will drill
        % until its capital is finished.
        while(npv > producer.NPVaggrConserv(t)&& ...
                (producer.capital(t) > (producer.NPVestimatorInput.drillCost...
                +producer.NPVestimatorInput.comCost)))
            
            producer = investInNewWell(producer,t);
        end

    case 'NPV_rig'
        % npv > producer.NPVaggrConserv
        % rigs available
        availableRigs = producer.rigs(t) * producer.wellsPerRigRate(t);
        while(npv > producer.NPVaggrConserv(t)&& ...
                availableRigs>0)
            availableRigs = availableRigs-1;
            producer = investInNewWell(producer,t);
        end
    case 'cash_rig'
        % capital > drilling cost and completion cost
        % available rig
        availableRigs = producer.rigs(t) * producer.wellsPerRigRate(t);
        while( (producer.capital(t)>(producer.NPVestimatorInput.drillCost...
                +producer.NPVestimatorInput.comCost))...
               && (availableRigs>0))
            
            
            availableRigs = availableRigs-1;
            producer = investInNewWell(producer,t);
        end
    case 'NPV_cash_rig'
        % npv > producer.NPVaggrConserv
        % capital > drilling cost and completion cost
        % available rig
        availableRigs = producer.rigs(t) * producer.wellsPerRigRate(t);
        while(...
                (npv > producer.NPVaggrConserv(t)) && ...
                (producer.capital(t)>(producer.NPVestimatorInput.drillCost...
                +producer.NPVestimatorInput.comCost))...
                && (availableRigs>0))
            
            
            availableRigs = availableRigs-1;
            producer = investInNewWell(producer,t);
        end
    case 'productionAim'
        % The producer tries aim for a pre-set production rate.
        % If so, the prodAim of the producer must be set. 
        if(t+producer.drillTime+producer.compTime <T)
            while((producer.totalProd(t)+...
                    producer.anticipatedProdAdd(t+producer.drillTime+producer.compTime))...
                    <producer.prodAim(t+producer.drillTime+producer.compTime))
                
                producer = investInNewWell(producer,t);
                producer.anticipatedProdAdd(t+producer.drillTime+producer.compTime)=...
                    producer.anticipatedProdAdd(t+producer.drillTime+producer.compTime)...
                    + producer.NPVestimatorInput.q0;
            end
        end
    case 'NPV_risk'
        % EXPERIMENTING!
        % Constraints:
        % max available rigs,
        % npv > producer.NPVaggrConserv.
        % 
        % When the oilprice is lower, the producer will invest in fewer
        % wells. 
        
        % Calcucalte the number of wells to produce:
        maxrigs = producer.rigs(t) * producer.wellsPerRigRate(t);
        start = producer.NPVaggrConserv(t); 
        stop = producer.NPVestimatorInput.drillCost + producer.NPVestimatorInput.comCost;
        start = start -stop*.2; 
        stop = stop * .1;
        
        if(npv> stop)
            drillNum = maxrigs;
        elseif((npv<stop) && (npv>start))
            k = maxrigs/(stop - start);
            drillNum = round(npv*k);
        else
            drillNum = 0;
        end
        
        while(drillNum>0)
            drillNum = drillNum-1;
            producer = investInNewWell(producer,t);
        end
    otherwise
        str = sprintf('Unknown strategy of producer');
        disp(str);
end % End: switch strategy

end

