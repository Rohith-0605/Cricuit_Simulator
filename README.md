Circuit-Simulator---MATLAB
This circuit simulator reads a text input file representing the circuit and determines the node voltages using the Modified Node Analysis algorithm.

This circuit simulator works for any circuit which consists of only independent voltage sources, independent current sources, and passive elements such as Resistors, Capacitors, and Inductors.

Text input file must include a net list of the circuit. Creating the netlist is visualized by an image. Check the "Netlist Example.PNG" file and also the "Netlist Example.txt" file in the Circuit Simulator directory.

Modified Node Analysis (MNA) Algorithm:
MNA applied to a circuit with only passive elements and independent current and voltage sources results in a matrix equation of the form:
A ∙ x = z
Let’s suppose we have the following:

For a circuit with n nodes and m independent voltage sources:

The A matrix:
is of size (n+m) × (n+m), and consists only of known quantities.

The upper-left nxn part (called G matrix):

Contains only passive elements.

Elements connected to ground appear only on the diagonal.

Elements not connected to ground appear on both diagonal and off-diagonal positions.

The rest of the A matrix (outside the nxn block) contains only 1, -1, and 0.

The x vector:
is an (n+m)×1 column vector holding the unknown quantities (node voltages and currents through the independent voltage sources).

Top n entries represent the n node voltages.

Bottom m entries represent the currents through the m independent voltage sources.

The z vector:
is an (n+m)×1 column vector containing known values.

The top n elements correspond to contributions from independent current sources.

The bottom m elements are values of the m independent voltage sources.

Support for Capacitors and Inductors
This simulator also supports capacitors (C) and inductors (L) using symbolic Laplace-domain analysis.

Capacitors are modeled as:

𝑌c = 𝑠⋅𝐶

Inductors are modeled as:

𝑌L = 1/𝑠⋅𝐿
​ 
Resistors are modeled as:

𝑌𝑅=1/R
 
When multiple passive elements (R, C, L) are connected between the same two nodes, their admittances are summed (i.e., treated as connected in parallel). For example, if R1, C1, and L1 are between nodes A and B, the total admittance added to the G matrix is:

𝑌𝑡o𝑡a𝑙= 𝑠⋅𝐶 + 1/𝑠⋅𝐿 + 1/R

 
The system is solved in the s-domain symbolically. After solving x = A \ z, the solution is transformed back into the time domain using MATLAB’s ilaplace() function:

x_time = ilaplace(x, s, t);

REFERENCES:
1. 2024,  EE 204 Circuit Theory Course, IIT GUWAHATI.
2. http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA3.html
3. http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA6.html
