 %let'sss goo
filename = input('What is the name of the circuit input file?\n', 's');
fid = fopen(filename, 'r');

if fid == -1
    error('Failed to open the file. Check if the file exists or the path is correct.');
end

% Read file (assuming up to 4 items per line as in your code)
fileIn = textscan(fid, '%s %s %s %s'); 
fclose(fid); % Close the file after reading
[Name, N1, N2, arg3] = fileIn{:};

nlines = length(Name);% Number of lines in file (or elements in circuit).

N1=str2double(N1); % Get node numbers
N2=str2double(N2);


n = max([N1; N2]); % Find highest node number (i.e., number of nodes)

m=0; % "m" is the number of voltage sources, determined below.
for k1=1:nlines                  % Check all lines to find voltage sources
    switch Name{k1}(1)
        case {'V'}  % These are the circuit elements with
            m = m + 1;             % We have voltage source, increment m.
    end
end

% Preallocate all arrays (use Litovski's notation).
% Initialize matrices and vectors
G = repmat({'0'}, n, n);  % nxn cell array filled with '0'
B = repmat({'0'}, n, m);  % nxm cell array filled with '0'
C = repmat({'0'}, m, n);  % mxn cell array filled with '0'
D = repmat({'0'}, m, m);  % mxm cell array filled with '0'

i = repmat({'0'}, n, 1);  % nx1 cell vector filled with '0'
e = repmat({'0'}, m, 1);  % mx1 cell vector filled with '0'
j = repmat({'0'}, m, 1);  % mx1 cell vector filled with '0'
v=compose('v_%d',(1:n)');          % v is filled with node names

% We need to keep track of the number of voltage sources we've parsed
% so far as we go through file.  We start with zero.
vsCnt = 0;

% This loop does the bulk of filling in the arrays.  It scans line by line
% and fills in the arrays depending on the type of element found on the
% current line.
for k1=1:nlines
    n1 = N1(k1);   % Get the two node numbers
    n2 = N2(k1);
    switch Name{k1}(1)
        % Passive element
        case {'R', 'L', 'C'} % RXXXXXXX N1 N2 VALUE
            switch Name{k1}(1)  % Find 1/impedance for each element type.
                case 'R'
                    g=['1/' Name{k1}];
                case 'L'
                    g=['1/s/' Name{k1}];
                case 'C'
                    g=['s*' Name{k1}];
            end
            % Here we fill in G array by adding conductance.
            % The procedure is slightly different if one of the nodes is
            % ground, so check for thos accordingly.
            if (n1==0)
                G{n2,n2} = sprintf('%s + %s',G{n2,n2},g);  % Add conductance.
            elseif (n2==0)
                G{n1,n1} = sprintf('%s + %s',G{n1,n1},g);  % Add conductance.
            else
                G{n1,n1} = sprintf('%s + %s',G{n1,n1},g);  % Add conductance.
                G{n2,n2} = sprintf('%s + %s',G{n2,n2},g);  % Add conductance.
                G{n1,n2} = sprintf('%s - %s',G{n1,n2},g);  % Sub conductance.
                G{n2,n1} = sprintf('%s - %s',G{n2,n1},g);  % Sub conductance.
            end
            
        % Independent voltage source.
        case 'V' % VXXXXXXX N1 N2 VALUE    (N1=anode, N2=cathode)
            vsCnt = vsCnt + 1;  % Keep track of which source this is.
            % Now fill in B and C arrays (again, process is slightly
            % different if one of the nodes is ground).
            if n1~=0
                B{n1,vsCnt} = [B{n1,vsCnt} ' + 1'];
                C{vsCnt, n1} = [C{vsCnt, n1} ' + 1'];
            end
            if n2~=0
                B{n2,vsCnt} = [B{n2,vsCnt} ' - 1'];
                C{vsCnt, n2} = [C{vsCnt, n2} ' - 1'];
            end
            e{vsCnt}=Name{k1};         % Add Name of source to RHS
            j{vsCnt}=['I_' Name{k1}];  % Add current through source to unknowns
            
        % Independent current source
        case 'I' % IXXXXXXX N1 N2 VALUE  (Current N1 to N2)
            % Add current to nodes (if node is not ground)
            if n1~=0
                i{n1} = [i{n1} ' - ' Name{k1}]; % subtract current from n1
            end
            if n2~=0
                i{n2} = [i{n2} ' + ' Name{k1}]; % add current to n2
            end
           
    end
end
%%  The submatrices are now complete.  Form the A, x, and z matrices,
% and solve!

A = str2sym([G B; C D]); %Create and display A matrix
fprintf('\nThe A matrix: \n');
disp(A);

x=str2sym([v;j]);       %Create and display x matrix
fprintf('\nThe x matrix: \n');
disp(x);

z=str2sym([i;e]);       %Create and display z matrix
fprintf('\nThe z matrix:  \n');
disp(z);

% Find all variables in matrices (symvar) and make them symbolic (syms)
syms([symvar(A), symvar(x), symvar(z)]);

% Displey the matrix equation
fprintf('\nThe matrix equation: \n');
disp(A*x==z)

a= simplify(A\z);  % Get the solution, this is the heart of the algorithm.

% This seems like an awkward way of doing this, if you know of a better way
% please contact me.
for i=1:length(a)  % Assign each solution to its output variable.
    eval(sprintf('%s = %s;',x(i),a(i)));
end

fprintf('\nThe solution:  \n');
disp(x==eval(x))



%% Lastly, assigning any numeric values to symbolic variables.
for k1=1:nlines
    switch Name{k1}(1)
        case {'R', 'L', 'C', 'V', 'I'}
            [num, status] = str2num(arg3{k1}); %#ok<ST2NM
    end
    if status  % status will be true if the argument was a valid number.
        % If the number is valid, assign it to the variable.
        eval(sprintf('%s = %g;',Name{k1}, num));
    end
end





