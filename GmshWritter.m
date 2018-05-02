function GmshWritter (filename, tnts, dt, tnn, nitrt, u, meshpreamble, pr, steps)

% Inputs:    
%       filename: The preamble for the filename_#.msh
%       tnts: Total number of time steps. For steady-state problems tnts=0.
%       dt: Time step. For steady-state problems it is 1. 
%       tnn: Total number of nodes in the mesh. 
%       nitrt: Nodes iterator. 1:tnn
%       u: It is the solution with dimensions (tnn x tnts) 
%       meshpreamble: For transient problems 'no', for steady-state 'yes'.
%       pr: If there are periodic quantities in the mesh provide '1'
%       steps: In transient problems it is the number of steps between two output .msh files.
%       1:steps:tnts
% 
% Author:   Abdullah WASEEM
% Email:    engineerabdullah@ymail.com
% Last Modified: 28 August, 2017

% read the current .msh file again
cd PreProcessing/meshfiles/
fileID = fopen([filename '.msh'], 'r');
fromfolder = pwd;
cd ../../PostProcessing/

% Check for the output folder, if its not present creates it.
thefolder = './Gmsh_Output';
if exist(thefolder,'dir') == 0
	mkdir(thefolder);
end
cd(thefolder);
delete *.msh
tofolder = pwd;
% Copying original msh file to the output folder.
copyfile([fromfolder '/' filename '.msh'], [tofolder '/' filename '.msh'])

% Removing the part from $Periodic to $EndPeriodic -- otherwise GMSH gives an error.
if pr ~= 0
    fin  = fopen([filename '.msh']);
    fout = fopen([filename '1.msh'], 'wt');
    tline = fgetl(fin);
    while ~(strcmp(tline, '$Periodic'))
        fprintf(fout, '%s\n', tline);
        tline = fgetl(fin);
    end
    fclose(fin); fclose(fout);
    delete([filename '.msh']);
    movefile([filename '1.msh'],[filename '.msh']);
end

% Format to save nodes number and result.
frmt = '%d %f\n';
% Saving files for each time step.
for t = 1 : steps : tnts + 1
    
    % Copy the original file to a new file for each time step.
    % Creating name string
    currentfilename = [filename '_' num2str(t) '.msh'];
    
    switch meshpreamble
        case 'yes'
            % Copying file
            copyfile([filename '.msh'], currentfilename);
            % Open current file
            fileID = fopen(currentfilename, 'a');
        case 'no'
            fileID = fopen(currentfilename, 'a');
            fprintf(fileID,'$MeshFormat\n');
            fprintf(fileID,'2.2 0 8\n');
            fprintf(fileID,'$EndMeshFormat\n');
    end
    
    % Append $NodeData
    fprintf(fileID, '$NodeData\n');
    % Append the number_of_string_tag
    fprintf(fileID, '1\n');
    % Append the string_tag
    fprintf(fileID, '"Temperature"\n');
    % Append a real_tag
    fprintf(fileID, '1\n');
    % Append time value at this step i.e. dt*t
    fprintf(fileID, [num2str(dt*(t-1)) '\n']);
    % Append number of integer tags (these are three)
    fprintf(fileID, '3\n');
    % first is the time step
    fprintf(fileID, [num2str(t-1) '\n']);
    % second is the type of field (1 for scalar)
    fprintf(fileID, '1\n');
    % third is the number of nodes in the mesh
    fprintf(fileID, [num2str(tnn) '\n']);
    % Append solution at current time step (size 2xtnn)
    vectoprnt = [nitrt; u(:,t)'];
    fprintf(fileID, frmt, vectoprnt);
    % Append $EndNodeData
    fprintf(fileID, '$EndNodeData');
    
    % Close current file
    fclose(fileID);
end

end
