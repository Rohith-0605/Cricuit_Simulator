%This function will create a G matrix with R, C, L support
function G = GProducer(inputCell)   

syms s; % Laplace variable

n = max(inputCell{3}); % G will be nxn matrix
G = sym(zeros(n));     % Use symbolic zeros

% Loop to fill diagonal terms
for i = 1:length(inputCell{1})
    name = inputCell{1}{i};
    value = inputCell{4}(i);

    % Determine the admittance based on element type
    if (sum(count(name, 'R')) == 1)
        Y = 1 / value;
    elseif (sum(count(name, 'C')) == 1)
        Y = s * value;              % Capacitor: Y = sC
    elseif (sum(count(name, 'L')) == 1)
        Y = 1 / (s * value);        % Inductor: Y = 1/sL
    else
        continue;  % skip if not R, C, or L
    end

    % If element is between two nodes (not ground)
    if inputCell{2}(i) ~= 0
        s_node = inputCell{2}(i);
        G(s_node, s_node) = G(s_node, s_node) + Y;
        
        r_node = inputCell{3}(i);
        G(r_node, r_node) = G(r_node, r_node) + Y;
    else
        % If connected to ground
        p = inputCell{3}(i);
        G(p, p) = G(p, p) + Y;
    end
end

% Loop to fill off-diagonal terms
for i = 1:length(inputCell{1})
    name = inputCell{1}{i};
    value = inputCell{4}(i);

    % Determine the admittance again
    if (sum(count(name, 'R')) == 1)
        Y = 1 / value;
    elseif (sum(count(name, 'C')) == 1)
        Y = s * value;
    elseif (sum(count(name, 'L')) == 1)
        Y = 1 / (s * value);
    else
        continue;
    end

    % Only for non-ground connected components
    if inputCell{2}(i) ~= 0
        k = inputCell{2}(i);
        m = inputCell{3}(i);

        G(k, m) = G(k, m) - Y;
        G(m, k) = G(m, k) - Y;
    end
end

end
