function wellsPerRigRate = loadWellsPerRigRate(filename,sheet,range)
global T
wellsPerRigRate = ones(T,1);
if(nargin==3)
    % Default file, sheet and range:
    fprintf('\nLoading wells per rig rate...\n');
    
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
                wellsPerRigRate = data;
            elseif(dlength<T)
                
                % Use the last value of input in the rest of the
                % simulation. 
                wellsPerRigRate(1:dlength) = data;
                wellsPerRigRate((dlength+1):end) = data(end);
                
                %% Another way: 
%                 element = floor(T/dlength);
%                 start = 1;
%                 for i = 1:dlength
%                     wellsPerRigRate(start:start+element) = data(i);
%                     start = start+element;
%                 end
%                 if(start<T) % If the length of adjustment data vector is not fully
%                     % "dividible" with T, the last elements in the
%                     % adjustment vector are assigned with the last
%                     % adjustment value:
%                     for(i = start:T)
%                         wellsPerRigRate(i) = data(end);
%                     end
%                 end
            else
                % IF: dlength>T
                wellsPerRigRate = data(1:T);
                
            end
            needInput = 0;
        catch
            fprintf('\nError when trying to load file.\n');
            filename = input('Type filename incl file extension:\n','s');
            sheet = input('Type the name of the sheet:\n','s');
            range = input('Type the range:\n','s');
        end
    end
elseif(nargin==1 && isfloat(filename))
    % use the first input variable as maximum rig count throughout all
    % time. 
    wellsPerRigRate = ones(T,1)*filename;  
elseif(nargin==0)
    wellsPerRigRate = ones(T,1)*50;
end
end

