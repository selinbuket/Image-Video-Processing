clc;
clear all;
close all;


%VIDEO READER

vid=VideoReader('C:\Program Files\MATLAB\R2019a\toolbox\vision\visiondata\viptrain.avi');
n = vid.NumberOfFrames;
  
%ORIGINAL FRAME WRITER

Folder = 'C:\Users\'; % Folder directory to write original frames 
for iFrame = 1:280
  frames = read(vid, iFrame);
  imwrite(frames, fullfile(Folder, sprintf('%06d.jpg', iFrame)));
end 

%{
FileList = dir(fullfile(Folder, '*.jpg'));
for iFile = 1:length(FileList)
 aFile = fullfile(Folder, FileList(iFile).name);
  img   = imread(aFile);
end
%}

%ANNOTATER

Folder2 = 'C:\Users\'; % Folder directory to write annotated frames
%I = imread('pic4.jpg');
for n=1:280
images{n} = imread(sprintf('%06d.jpg',n));
detector= peopleDetectorACF;
[bboxes,scores] = detect(detector,images{n});
images{n} = insertObjectAnnotation(images{n},'rectangle',bboxes,scores);
N(n)=length(scores);
imwrite(images{n}, fullfile(Folder2, sprintf('%06d.jpg',n)));
end


%VIDEO CREATOR


% Make an avi movie from a collection of jpg images in a folder.
% Specify the folder.
myFolder = 'C:\Users\'; % Folder directory to create video
% Get a directory listing.
filePattern = fullfile(myFolder, '*.JPG');
jpgFiles = dir(filePattern);
writerObj = VideoWriter('YourAVI.avi');
open(writerObj);
% Go through image by image writing it out to the AVI file.
for frameNumber = 1 : length(jpgFiles)
    % Construct the full filename.
    baseFileName = jpgFiles(frameNumber).name;
    fullFileName = fullfile(myFolder, baseFileName);
    % Display image name in the command window.
    %fprintf(1, 'Now reading %s\n', fullFileName);
    % Display image in an axes control.
    thisimage = imread(fullFileName);
    imshow(thisimage);  % Display image.
    
    if frameNumber==281
        break
    end
    title( ['Number of People Detected: ',num2str(N(frameNumber))]);
    drawnow; % Force display to update immediately.
    % Write this frame out to the AVI file.
    
    writeVideo(writerObj, thisimage);
end
% Close down the video writer object to finish the file.
close(writerObj);

