%% Load data
% load surface
[v, f]= read_vtk('surfaceFile.vtk'); 
S = struct('tri',f','coord',v);

% Load ROI values mapped to surface, should be length 1 x v
%   Use your GIFTI load code
mappedROIs = Load_and_Combine_vtkmetric( marsLeft, marsRight ); 

% Load Subject data 
Sub_fn = {"1.nii" "2.nii"}; % files to load

SubData = zeroes(size(Sub_fn,2),size(v,2)); % initialize matrix

for i = 1:size(Sub_fn,2) % loop through and load files
    SubData(i,:) = Load_and_Combine_vtkmetric( SubLeft, SubRight ); %   Use your GIFTI load code
end


% End of Load Data

%% Extract ROI values

numROIs = max(mappedROIs); % get the number of ROIs to loop through 

ROI_values = zeroes(size(Sub_fn,2),numROIs); % initialize matrix

for k = 1:numROIs  %for each of the labels
    maskROI = mappedROIs == k;  %make a matrix of 0,1's where the desired label is
    ROI_values(:,k) = nanmean( SubData(:, maskROI), 2 ); %%Calculates the ROI values for every subject in the vtk file
end


%% Map the ROI values to the ROI's
% now if you have performed some calculations, and want to remap the values
% onto the cortex, you can use this code. 
someValueCalculated = zeros(1,numROIs);
ROI_metric = someValueCalculated;

remappedROI = zeros(1,size(mappedROIs,2));
%use the above values to map the cortex based on ROIs
for k = 1:numROIs
    remappedROI(mappedROIs==k) = ROI_metric(k);
end

% visualize the results
figure;
SurfStatViewData_marm(remappedROI, S, 'title',[0.7 0.7 0.7])
SurfStatColLim([0 10]), colormap(freesurf_colourmap)
