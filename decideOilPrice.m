function oilPrice = decideOilPrice(filename,sheet,range)
global T
%% Load oil Price
oilPrice = zeros(T,1);

if(nargin==3)
    % Default file, sheet and range:
    fprintf('\nLoading oil price:\n');
    
    needInput = 1; % Loop parameter.
    while(needInput)
        try
            fprintf('\tTrying to read input file:\n');
            fprintf('\tFilename: %s\n',filename);
            fprintf('\tSheet: %s\n',sheet);
            fprintf('\tRange: %s\n',range);
            %answer = input('Continue?: [y]\n','s');
            %if(answer == 'y')
                [price, Months] = xlsread(filename,sheet,range);
                datalen = length(price);
                
                if(T == datalen)
                    oilPrice = price;
                elseif(T<datalen)
                    % If the imported data is longer than the simulation
                    % time, just use the part of the imported data you
                    % need. 
                    oilPrice = price(1:T);
                else % The imported data vector is shorter than T. 
                    
                    fprintf('The array of the input data is shorter than the simulation length.\n');
                    fprintf('What do you want to do:\n');
                    fprintf('    1.Use the last value of the oilprice in the rest of the simulation.\n');
                    fprintf('    2.Use the input array as a mean and spread the values out.\n');
                    svar = input('    Choose 1 or 2:  ');
                    if(svar==1)
                        % If the imported data vector is too short, use the
                        % last value of the imported vector for the rest of the
                        % time steps.
                        oilPrice(1:datalen) = price;
                        oilPrice((datalen+1):end) = price(end);
                    else
                        element = floor(T/datalen);
                        start = 1;
                        for i = 1:datalen
                            oilPrice(start:start+element) = price(i);
                            start = start+element;
                        end
                        if(start<T) % If the length of adjustment data vector is not fully
                            % "dividible" with T, the last elements in the
                            % adjustment vector are assigned with the last
                            % adjustment value:
                            for(i = start:T)
                                oilPrice(i) = price(end);
                            end
                        end
                    end
                end
                needInput = 0;
%             else
%                 filename = input('Type filename incl file extension:\n','s');
%                 sheet = input('Type the name of the sheet:\n','s');
%                 range = input('Type the range:\n','s');
%            end
        catch
            fprintf('\nError when trying to load file.\n');
            filename = input('Type filename incl file extension:\n','s');
            sheet = input('Type the name of the sheet:\n','s');
            range = input('Type the range:\n','s');
        end
    end
else % Else, we have an endogenous oil price:
    for t = 1:T
        if(t == 1)
            oilPrice(t) = 120; % Oil price
        elseif(t == 100 || t==40)
            oilPrice(t) = 60;
        elseif(1<t && t<40)
            oilPrice(t) = oilPrice(t-1)^(.01/12+1) + (rand()-0.5)*10;
            %oilPrice(t) = oilPrice(t-1) + (rand()-0.5)*10;
        elseif(200<t && t<=T)
            oilPrice(t) = oilPrice(t-1)^(.005/12+1) + (rand()-0.5)*10;
        else
            oilPrice(t) = oilPrice(t-1)^(.01/12+1) + (rand()-0.5)*10;
        end
    end
    
end

end

