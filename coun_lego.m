function [numA,numB]=count_lego(I)
 %In this coursework, object detection was performed using blob analysis.
 %Commands and fuctions provided by the computervision toolbox were used. This
 %method was used since it allowed the isolation of lego pieces by colour. Then to
 %count the lego pieces of interest. Blob analysis was used to select them 
 %based on pixel size. Other object detection methods were combined with blob 
 %detection but since they did not provide any additional acurracy, they
 %were not implemented.
 %The code was inspired by the matlab video below. 
 % source:https://www.youtube.com/watch?v=DJ3wBLrAolY&t=112s
 
 %read image 
 I1 = imread(I); 
 
 %convert image b
 Ib = rgb2hsv(I1);
 
% Define thresholds for channel 1 based on histogram settings
channel1Minb = 0.570;
channel1Maxb = 0.622;

% Define thresholds for channel 2 based on histogram settings
channel2Minb = 0.446;
channel2Maxb = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Minb = 0.034;
channel3Maxb = 1.000;

% Create mask based on chosen histogram thresholds
 sliderBW = (Ib(:,:,1) >= channel1Minb ) & (Ib(:,:,1) <= channel1Maxb) & ...
    (Ib(:,:,2) >= channel2Minb ) & (Ib(:,:,2) <= channel2Maxb) & ...
    (Ib(:,:,3) >= channel3Minb ) & (Ib(:,:,3) <= channel3Maxb);

 BWb = sliderBW;
 
%convert image r
Ir = rgb2hsv(I1);

% Define thresholds for channel 1 based on histogram settings
channel1Minr = 0.961;
channel1Maxr = 0.008;

% Define thresholds for channel 2 based on histogram settings
channel2Minr = 0.442;
channel2Maxr = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Minr = 0.000;
channel3Maxr = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (Ir(:,:,1) >= channel1Minr) | (Ir(:,:,1) <= channel1Maxr) ) & ...
    (Ir(:,:,2) >= channel2Minr ) & (Ir(:,:,2) <= channel2Maxr) & ...
    (Ir(:,:,3) >= channel3Minr ) & (Ir(:,:,3) <= channel3Maxr);

BWr = sliderBW;

%clear noise in the image 
rec = strel('diamond',4);
Ibc=imopen(BWb,rec);
Irc=imopen(BWr,rec);

% perform blob analysis for both images 
Hbb= vision.BlobAnalysis('MinimumBlobArea',25000,'MaximumBlobArea',200000);
Hbr= vision.BlobAnalysis('MinimumBlobArea',5000,'MaximumBlobArea',38900);
[~,~,bbox_b]=Hbb(Ibc);
[~,~,bbox_r]=Hbr(Irc);

 %insert shapes in the image to show matches 
 matche_b = insertShape(I1,'Rectangle',bbox_b,'LineWidth',6); 
 matche_r = insertShape(I1,'Rectangle',bbox_r,'LineWidth',6);
 
 %count the number of bounding boxes 
 numA = (numel(bbox_b))/4;
 numB = (numel(bbox_r))/4;
 
 %show results 
 figure(1),subplot(1,2,1), imshow(matche_b), title(['count blue = ',num2str(numA)]),subplot(1,2,2),imshow(Ibc);
 figure(2),subplot(1,2,1), imshow(matche_r), title(['count red = ',num2str(numB)]),subplot(1,2,2),imshow(Ibc);
 
end