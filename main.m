close all
clear all
clc

addpath './Code/g2o_utils'
addpath './Code/visualization'
addpath './Code/utils'
addpath './Code/ICP'


%load ground truth dataset and initial guess dataset
[landmarks_gt, poses_gt, transitions_gt, observations_gt] = loadG2o('./Dataset/slam2d_range_only_ground_truth.g2o');
[~, poses, transitions, observations] = loadG2o('./Dataset/slam2d_range_only_initial_guess.g2o');

% Get initial guess of landmarks using LS
% The third parameter is a threshold, it discards two observations if they are too similar
landmarks_LS = LS_landmarks_initialization(poses, observations, 0.5);
printf("\nInitialized landmarks: %d\n\nStarting ICP...\n", size(landmarks_LS, 2))

% Solve problem with LS
[poses_opt, landmarks_opt, chi_stats] = solveMultiICP(poses, landmarks_LS, observations, transitions, 20);

% The solution is aligned with the first pose of the initial guess (prior added)
% but we want a beautiful plot (FOR VISUAL PURPOSES [not mandatory])
% This transforms to have the first pose in the give position
[poses, landmarks_LS] = rotateAndTranslate(poses, landmarks_LS, [0; 0; 0]);
[poses_opt, landmarks_opt] = rotateAndTranslate(poses_opt, landmarks_opt, [0; 0; 0]);
[poses_gt, landmarks_gt] = rotateAndTranslate(poses_gt, landmarks_gt, [0; 0; 0]);

% plot error stats
figure();
plot(chi_stats)
title('Error during iterations');

% Plot map and trajectory
figure();
title('Map and trajectory');
fig = gcf ();
set(fig, 'units', 'normalized', 'position', [0.125 0 0.75 1])
p_gt = drawPoses(poses_gt, 'g*');
p = drawPoses(poses, 'y*');

l_gt = drawLandmarks(landmarks_gt, 'b*');
l_LS = drawLandmarks(landmarks_LS, 'c*');

p_opt = drawPoses(poses_opt, 'r*');
l_opt = drawLandmarks(landmarks_opt, 'm*');

drawLandCorrespondences(landmarks_gt, landmarks_opt, [0.66, 0.66, 0.66])
drawLandCorrespondences(landmarks_LS, landmarks_opt, [0.27, 0.27, 0.27])

legend([p, p_opt, p_gt, l_LS, l_opt, l_gt], {"Initial Poses", "Poses Optimizated", "Poses Ground truth", "Initial Landmarks", "Landmarks Optizated", "Landmarks ground truth"})


%drawnow;

%pause(100)



