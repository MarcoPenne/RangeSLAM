close all
clear
clc

%addpath '../'
addpath './Code/g2o_utils'
addpath './Code/visualization'
addpath './Code/utils'
addpath './Code/ICP'
%source "../tools/utilities/geometry_helpers_2d.m"

%addpath "./solution" 

%load ground truth dataset and initial guess dataset
[landmarks_gt, poses_gt, transitions_gt, observations_gt] = loadG2o('./Dataset/slam2d_range_only_ground_truth.g2o');
[~, poses, transitions, observations] = loadG2o('./Dataset/slam2d_range_only_initial_guess.g2o');



landmarks = initializeLandmarks(poses, observations);
landmarks
[poses_opt, landmarks_opt, chi_stats] = solveMultiICP(poses, landmarks, observations, transitions, 20);
[poses_opt, landmarks_opt] = rotateAndTranslate(poses_opt, landmarks_opt)

figure();
plot(chi_stats)

figure();
fig = gcf ();
set(fig, 'units', 'normalized', 'position', [0 0 0.75 1])
p_gt = drawPoses(poses_gt, 'g*');
p = drawPoses(poses, 'y*');

%for i=1:size(landmarks_opt, 2)
%    land_opt_ids(end+1) = landmarks_opt(i).id;
%end
%drawRanges(poses, observations, [7]);

l_gt = drawLandmarks(landmarks_gt, 'b*');
l = drawLandmarks(landmarks, 'c*');

p_opt = drawPoses(poses_opt, 'r*');
l_opt = drawLandmarks(landmarks_opt, 'm*');

drawLandCorrespondences(landmarks_gt, landmarks_opt, [0.66, 0.66, 0.66])
drawLandCorrespondences(landmarks, landmarks_opt, [0.27, 0.27, 0.27])


legend([p, p_opt, p_gt, l, l_opt, l_gt], {"Initial Poses", "Poses Optimizated", "Poses Ground truth", "Initial Landmarks", "Landmarks Optizated", "Landmarks ground truth"})


%drawnow;

%pause(100)



