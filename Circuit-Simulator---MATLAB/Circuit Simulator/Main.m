syms s t

% Main script
inputCell = getInput();

n = max(inputCell{3});
m = sum(count(inputCell{1}, 'V'));

G = GProducer(inputCell);    % Symbolic G matrix (R, C, L handled)
B = BProducer(inputCell);    % Voltage source incidence matrix
C = B';
D = zeros(m);

A = [G, B; C, D];
z = zProducer(inputCell);

x = simplify(A \ z);         % Solve in Laplace domain
disp('Voltages and Currents in Laplace Domain (s-domain):');
disp(x);

% Convert voltages to time domain using inverse Laplace
x_time = ilaplace(x, s, t);
disp('Voltages and Currents in Time Domain (t-domain):');
disp(x_time);
