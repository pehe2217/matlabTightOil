function q0adj = decideInitialProductionAdjustment(filename,sheet,range)
% Decides a variable that adjusts the initial production rate for different
% months.
global T
q0adj = ones(T,1);
if(nargin==3)
    % Default file, sheet and range:
    fprintf('\nLoading values for adjusting the initial production...\n');
    
    needInput = 1; % Loop parameter.
    while(needInput)
        try
            fprintf('\tTrying to read input file:\n');
            fprintf('\tFilename: %s\n',filename);
            fprintf('\tSheet: %s\n',sheet);
            fprintf('\tRange: %s\n',range);
            %answer = input('Continue?: [y]\n','s');
            %if(answer == 'y')
            [data, text] = xlsread(filename,sheet,range);
            dlength = length(data);
            if(dlength==T)
                q0adj = data;
            elseif(dlength<T)
                element = floor(T/length(data));
                
                start = 1;
                for i = 1:dlength
                    q0adj(start:start+element) = data(i);
                    start = start+element;
                end
                if(start<T) % If the length of adjustment data vector is not fully 
                    % "dividible" with T, the last elements in the
                    % adjustment vector are assigned with the last
                    % adjustment value: 
                    for(i = start:T)
                        q0adj(i) = data(end);
                    end
                end
            else
                % dlength>T
                for i = 1:T
                    q0adj(i) = data(i);
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
    
    
end
end

