function rigs = loadRigs(filename,sheet,range)
global T
rigs = ones(T,1);
if(nargin==3)
    % Default file, sheet and range:
    fprintf('\nLoading data on rig count...\n');
    
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
                rigs = data;
            elseif(dlength<T)
                
                rigs(1:dlength) = data;
                rigs( (dlength+1):end) = data(end);
                
                % If you want to do it in another way, this works also:
                
%                 element = floor(T/length(data));
%                 
%                 start = 1;
%                 for i = 1:dlength
%                     rigs(start:start+element) = data(i);
%                     start = start+element;
%                 end
%                 if(start<T) % If the length of adjustment data vector is not fully 
%                     % "dividible" with T, the last elements in the
%                     % adjustment vector are assigned with the last
%                     % adjustment value: 
%                     for(i = start:T)
%                         rigs(i) = data(end);
%                     end
%                 end
            else
                % dlength>T
                for i = 1:T
                    rigs(i) = data(i);
                end
            end
            needInput = 0;
        catch
            fprintf('\nError when trying to load file.\n');
            filename = input('Type filename incl file extension:\n','s');
            sheet = input('Type the name of the sheet:\n','s');
            range = input('Type the range:\n','s');
        end
    end
elseif(nargin==1)
    % use the first input variable as maximum rig count throughout all
    % time. 
    rigs = ones(T,1)*filename;  
elseif(nargin==0)
    rigs = ones(T,1)*50;
end
end

