%This function will create a B matrix
function B = BProducer(inputCell)  
%B will be a nxm matrix
n = max(inputCell{3});
m = sum(count(inputCell{1},'V'));

%Let's start with a nxm 0 matrix
B = zeros(n,m);

c = 1; % This variable will be used as column index. 
%If voltage source is connected between two nodes rather than ground(0 node)
for i = 1:length(inputCell{1})
       %The first condition verifies it is a voltage source. Counts how much V
       %in that value. If it is 'Vn', value will be 1, else it will be 0
        if  (sum(count(inputCell{1}(i),'V')) == 1) && (inputCell{2}(i) ~= 0)
            %
            B(inputCell{2}(i),c) = -1;
            B(inputCell{3}(i),c) = 1;
            c = c + 1; % column for Vc was written. Now next column will be
            %for V(c+1) in next column[(c+1)th column] 
        end
end        
            % c(column index) was not refreshed. So next loop will
            % continue at next column
            
%If voltage source is connected to ground(0 node)            
for i = 1:length(inputCell{1})
           %The first condition verifies it is a voltage source. Counts how much V
       %in that value. If it is 'Vn', value will be 1, else it will be 0
        if  (sum(count(inputCell{1}(i),'V')) == 1) && (inputCell{2}(i) == 0)
            B(inputCell{3}(i),c) = 1;
            c = c + 1; % column for Vc was written. Now next column will be
            %for V(c+1) in next column[(c+1)th column] 
        end
end
end