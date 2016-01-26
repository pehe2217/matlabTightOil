function yyyymm = my_yearmonth(startyear,timestep)
% Returns a string representing year and month on the format 'yyyy-mm'. 

yyyy = startyear + floor((timestep-1)/12);
if(mod(timestep,12)==0)
    mm = 12;
else
    mm = mod(timestep,12);
end
yyyymm = strcat(num2str(yyyy),'-',num2str(mm));

end