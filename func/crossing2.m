function crossing_position = crossing2(t,y, crossing_level)
%finds indexs where "y" data crosses a certain threshold. 
%Differentiates between crossings with positive, negative, and zero slop

%note: just takes the time before crossing as crossing time. Will be
%problematic for data sets that don't have very high temporal resolution
dum1=0;
dum2=0;
dum3=0;
% crossing_equal=0;
% crossing_pos=0;
% crossing_neg=0;
for i = 1:length(y)-1
    if y(i) == crossing_level      %equals crossing level
        dum1=dum1+1;
        crossing_equal(dum1) = i;
    elseif y(i+1)> crossing_level && y(i)< crossing_level      %positive slope
        dum2=dum2+1;
        crossing_pos(dum2) = i;
    elseif y(i+1)< crossing_level && y(i)> crossing_level  %negative slope
        dum3=dum3+1;
        crossing_neg(dum3) = i;
    end
end

crossing_position = [];
if exist('crossing_equal')
    crossing_position = sort([crossing_position crossing_equal]);
end
if exist('crossing_pos')
    crossing_position = sort([crossing_position crossing_pos]);
end
if exist('crossing_neg')
    crossing_position = sort([crossing_position crossing_neg]);
end