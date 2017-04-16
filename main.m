%
clc ; clear all; close all;

%Red eye correction

%% ============================== %%
%IN variables (modify for different results

%Eye size (default 2)
sizeEye = 2;
%Saturation level (default 0.5)
satLevel = 0.8;


%% ============================== %%
%Reading data and setup variables

%read image file
I = imread('./images/approved/ojo6.jpg');
Ih = rgb2hsv(I);

%Mask variable for preallocation
mask = zeros(length(I(:,1,:)),length(I(1,:,:)));

    
%% ========================================= %%
% Mask creation

%Find pixels with high red and saturation level and create a Binary Mask
for i=1:1:length(I(:,1,:))
    for j=1:1:length(I(1,:,:))
        if ((Ih(i,j,1)>0.9 || Ih(i,j,1)<0.02) && Ih(i,j,2) > satLevel)
            mask(i,j)=1;
        end
    end
end

    
%% ========================================= %%
% Mask fixing - Deleting small points

%Define disk filter
se = strel('disk',sizeEye);

%Filter mask
maskFiltered = imopen(mask,se);

%Augment circles. After processing it could be reduced
maskFixed = imdilate(maskFiltered,se);


%% ========================================= %%
% Mask fixing - Filtering eyes region

%There are possible false positives on the image, this code will clean it

%check how many white areas are in the binary mask image (n = num of areas,
%L = areas labeled)
[labeledRegions, nRegions]=bwlabel(maskFixed);

%If there are more than 2, delete extra areas
if (nRegions>2)
    %Get area properties of the labeled area image
    regProps = regionprops(labeledRegions);
    
    % get area properties
    regionAreas = [];
    for i=1:size(regProps,1)
        regionAreas = [regionAreas regProps(i).Area];
    end
    
    %delete all areas with  area-mean lower than the media
    areasMean = mean(regionAreas);
    indexHigherAreas = find([regProps.Area] > 2*areasMean);
    for i = 1:size(indexHigherAreas,2)
        boundBox = floor(regProps(indexHigherAreas(i)).BoundingBox);
        if boundBox(2) == 0
            boundBox(2) = 1;
        end
        if boundBox(1) == 0
            boundBox(1) = 1;
        end
        %delete it from binary mask image (turning 1 to 0)
        maskFixed(boundBox(2):boundBox(2)+boundBox(4),boundBox(1):boundBox(1)+boundBox(3)) = 0;
    end
end


%% ========================================= %%
%Apply mask onto RGB image

% Trabajamos en RGB
Icorrected = I;

%Apply mask on RGB image, changing pixel color into an R= mean(G + B)
for i=1:size(I,1)
    for j=1:size(I,2)
        if maskFixed(i,j)==1
            Icorrected(i,j,1)=(I(i,j,2)+I(i,j,3))/2;
        end
    end
end

%% ========================================= %% 
%Show results

figure,subplot(1,3,1),imshow(I),title('Original Image'),...
    subplot(1,3,2),imshow(Icorrected),title('Corrected Image'),...
    subplot(1,3,3),imshow(maskFixed),title('Mask');
