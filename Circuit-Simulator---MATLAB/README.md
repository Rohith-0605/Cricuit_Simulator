# Circuit-Simulator---MATLAB

This circuit simulator reads a text input file representing the circuit and determines the node voltages using the Modified Node Analysis algorithm.

This circuit simulator works for any circuit which consist of only independent voltage sources, independent current sources and passive elements such as Resistors, Capacitors, Inductors. 

Text input file must include a net list of the circuit. Creating netlist is visualized by a image. Check "Netlist Example.PNG" file and also "Netlist Example.txt" file at Circuit Simulator directory. 


Modified Node Analysis (MNA) algorithm:

MNA applied to a circuit with only passive elements and independent current and voltage
sources results in a matrix equation of the form:
A ∙ x = z

and based on the netlist example let's suppose we have

For a circuit with n nodes and m independent voltage sources:
• The A matrix, stated above:
 - is (n+m)x(n+m) in size, and consists only of known quantities.
 - the nxn part of the matrix in the upper left:
      ◦ has only passive elements
      ◦ elements connected to ground appear only on the diagonal
      ◦ elements not connected to ground are both on the diagonal and off-diagonal terms.
      • The rest of the A matrix (not included in the nxn upper left part) contains only 1, -1 and 0.

The x matrix:
  - is an (n+m)x1 vector that holds the unknown quantities (node voltages and the currents
  through the independent voltage sources).
  - the top n elements are the n node voltages.
  - the bottom m elements represent the currents through the m independent voltage sources
  in the circuit.

The z matrix:
  - is an (n+m)x1 vector that holds only known quantities
  - the top n elements are either zero or the sum and difference of independent current sources
  in the circuit.
  - the bottom m elements represent the m independent voltage sources in the circuit.
  The unknown quantities can be obtained by solving the linear system of equations A ∙ x = z .

REFERENCES:
1. EE 204 Circuit theory Course, IIT GUWAHATI.
2. http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA3.html
3. http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA6.html
