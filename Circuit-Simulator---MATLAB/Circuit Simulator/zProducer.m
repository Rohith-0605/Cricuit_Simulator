%This function will create a z matrix
function z = zProducer(inputCell) 
n = max(inputCell{3});
m = sum(count(inputCell{1},'V'));

%Z matrix is divided two vectors. First will arrange for currents. 
CurrentVector = zeros(n,1);
%There are 4 cases for I. The value of I can be positive or negative. The
%current can be connected ground or not. Next loop consider all
%combinations.
for i = 1:length(inputCell{1})
    %The next condition verifies it is a current source. Counts how much I
       %in that value. If it is 'In', value will be 1, else it will be 0
    if (sum(count(inputCell{1}(i),'I')) == 1)
        
        if inputCell{4}(i) > 0 && inputCell{2}(i) ~= 0
        CurrentVector(inputCell{3}(i),1) = -inputCell{4}(i);
        CurrentVector(inputCell{2}(i),1) = inputCell{4}(i);
        
        elseif inputCell{4}(i) < 0 && inputCell{2}(i) ~= 0
        CurrentVector(inputCell{3}(i),1) = inputCell{4}(i);
        CurrentVector(inputCell{2}(i),1) = -inputCell{4}(i);
        
        %Do not need to worry about 0 node in next condition
        elseif inputCell{4}(i) > 0 && inputCell{2}(i) == 0
        CurrentVector(inputCell{3}(i),1) = inputCell{4}(i);
        
        %Do not need to worry about 0 node in next condition
        elseif inputCell{4}(i) < 0 && inputCell{2}(i) == 0
        CurrentVector(inputCell{3}(i),1) = inputCell{4}(i);
        

        end
    end
end

%z matrix is divided two vectors. We arranged current vector. 
%This is the second part of z. 
VoltageVector = zeros(m,1); 

r = 1;% This variable will be used as row index.
for i = 1:length(inputCell{1})
        if (sum(count(inputCell{1}(i),'V')) == 1)
            VoltageVector(r,1) = inputCell{4}(i);
            r = r + 1;% row for Vr was written. Now next column will be
            %for V(r+1) in next row[(r+1)th row] 
        end
end
% The parts of z is merged by next operation
z = [CurrentVector;VoltageVector];
end