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
[poses_opt, landmarks_opt, chi_stats] = solveMultiICP(poses, landmarks, observations, 1);

figure();
plot(chi_stats)

figure();
%p_gt = drawPoses(poses_gt, 'b*');
%p = drawPoses(poses, 'g*');

for i=1:size(landmarks_opt, 2)
    land_opt_ids(end+1) = landmarks_opt(i).id;
end
%drawRanges(poses_opt, observations, [89]);

l_gt = drawLandmarks(landmarks_gt, 'b*');
%l = drawLandmarks(landmarks, 'g*');

%p_opt = drawPoses(poses_opt, 'r*');
l_opt = drawLandmarks(landmarks_opt, 'r*');

drawLandCorrespondences(landmarks_gt, landmarks_opt)

%legend([p_gt, p, p_opt, l_gt, l, l_opt], {"Poses Ground truth", "Poses initial guess", "Poses Opt", "Landmark ground truth", "Landmark initial guess", "Landmark Opt"})


%drawnow;

%pause(100)



