n = 3;
pr = [];
for qq = 1:n
    for DD = 1:n
        for bb = 1:n
            pr =[pr, (n*n*(qq-1) + n*(DD-1) + bb)];
        end
    end
end