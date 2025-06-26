%Next function will get data
inputCell = getInput();

%n is the number of nodes, found by the next line
n = max(inputCell{3});

% m is the number of independent voltage sources, found by counting 'V's
m = sum(count(inputCell{1},'V')); 

%This function will create G matrix
G = GProducer(inputCell);

%This function will create B matrix
B = BProducer(inputCell);

%C matrix is transpose of B
C = B';

%D is mxm zero matrix
D = zeros(m);

%Ax=z, next functions will create A and z matrices
A = [G,B;C,D];
z = zProducer(inputCell);

% x is a vector that shows node voltages respectively from 1 to n
x = inv(A)*z;

