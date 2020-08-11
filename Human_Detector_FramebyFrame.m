clc;
clear all;
close all;


%VIDEO READER

vid=VideoReader('C:\Users\asus\Desktop\walking.mp4'); % Folder directory of the video
n = vid.NumberOfFrames;
  
%ORIGINAL FRAMES WRITER

Folder = 'C:\Users\asus'; % Folder directory to write original frames
for iFrame = 1:10
  frames = read(vid, iFrame);
  imwrite(frames, fullfile(sprintf('%06d.jpg', iFrame)));
end 
%{
FileList = dir(fullfile(Folder, '*.jpg'));
for iFile = 1:length(FileList)
 aFile = fullfile(Folder, FileList(iFile).name);
  img   = imread(aFile);
end
%}

%ANNOTATER

Folder2 = 'C:\Users\asus\'; % Folder directory to write annotated frames
%I = imread('pic4.jpg');
for n=1:10
images{n} = imread(sprintf('%06d.jpg',n));
detector= peopleDetectorACF;
[bboxes,scores] = detect(detector,images{n});
images{n} = insertObjectAnnotation(images{n},'rectangle',bboxes,scores);
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
    drawnow; % Force display to update immediately.
    % Write this frame out to the AVI file.
    writeVideo(writerObj, thisimage);
end
% Close down the video writer object to finish the file.
close(writerObj);

