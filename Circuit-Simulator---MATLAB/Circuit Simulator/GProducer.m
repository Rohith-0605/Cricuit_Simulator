%This function will create a G matrix
function G = GProducer(inputCell)   

%Finding conductance will help
%I and V values will not be used

t = length(inputCell{4});
Conductance = zeros(t,1);

for i = 1:length(inputCell{4})
Conductance(i) = 1/inputCell{4}(i);
end

n = max(inputCell{3});% G will be nxn matrix

%Let start with nxn 0 matrix and add needed values to this matrix
G = zeros(n);

%Next loop makes diagonal part of G
for i = 1:length(inputCell{1})
       %The condition verifies it is a resistor. Counts how much R
       %in that value. If it is 'Rn', value will be 1, else it will be 0
    if (sum(count(inputCell{1}(i),'R')) == 1)
    %If resistance is connected between two nodes rather than ground(0 node)
        if (inputCell{2}(i) ~= 0)
              s = inputCell{2}(i);
    G(s,s) = G(s,s) + Conductance(i);
        r = inputCell{3}(i);
    G(r,r) = G(r,r) + Conductance(i);
        % The other case is when the resistance is connected ground(0 node)
        else 
       p = inputCell{3}(i);
    G(p,p) = G(p,p) + Conductance(i);
end
    end
end
%Next loop makes off diagonal part of G
for i = 1:length(inputCell{1})
    %The second condition verifies it is a resistor. Counts how much R
       %in that value. If it is 'Rn', value will be 1, else it will be 0
    if (inputCell{2}(i) ~= 0) && (sum(count(inputCell{1}(i),'R')) == 1)
        k = inputCell{2}(i);
        m = inputCell{3}(i);
        G(k,m) = G(k,m) - Conductance(i);
        G(m,k) = G(m,k) - Conductance(i);
    end
end
