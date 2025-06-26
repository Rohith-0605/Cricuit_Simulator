%This function will get data and assign it to inputCell
function inputCell = getInput()
fileName = input('What is the name of the circuit input file?\n','s');
fileID = fopen(fileName,'r');

%Checks file was opened succesfully or not
if fileID == -1
    disp('File open not succesful');
else
    inputCell = textscan(fileID,'%s %f %f %f');%This operation gets data
end

closeResult = fclose(fileID);
%Checks file was closed succesfully or not
if closeResult ~= 0
      disp('File close not successful');
end
end
