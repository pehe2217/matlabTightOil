function oilPrice = decideOilPrice(filename,sheet,range)
global T
%% Load oil Price
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
                [oilPrice, Months] = xlsread(filename,sheet,range);
                T = length(oilPrice);
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
    oilPrice = zeros(T,1);
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

