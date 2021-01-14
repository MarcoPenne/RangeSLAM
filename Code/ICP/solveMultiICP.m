function [poses_opt, landmarks_opt, chi_stats] = solveMultiICP(poses, landmarks, observations, n_iterations)

    % new_poses = [];
    % new_landmarks = [];
    % for i=1:size(observations,2)
    %     pose_id = observations(i).pose_id;
    %     land_id = observations(i).observation.id;
        
    %     new_poses(end+1) = pose_id;
    %     new_landmarks(end+1) = land_id;
        
    % end
    
    % for i=1:size(poses, 2)
    %     if any(new_poses==poses(i).id)
    %         new_new_poses(end+1) = poses(i);
    %     end
    % end
    % for i=1:size(landmarks, 2)
    %     if any(new_landmarks==landmarks(i).id)
    %         new_new_landmarks(end+1) = landmarks(i);
    %     end
    % end
    % poses=new_new_poses
    % landmarks=new_new_landmarks

    % Create mapping between indeces and IDs
    global pose_index2id = zeros(1,size(poses,2));
    for i=1:size(poses,2)
        pose_index2id(i) = poses(i).id;
    end
    global pose_id2index = zeros(1, pose_index2id(end));
    for i=1:size(pose_index2id, 2)
        pose_id2index(pose_index2id(i)) = i;
    end
    global landmark_index2id = zeros(1,size(landmarks,2));
    for i=1:size(landmarks,2)
        landmark_index2id(i) = landmarks(i).id;
    end
    global landmark_id2index = zeros(1, landmark_index2id(end));
    for i=1:size(landmark_index2id, 2)
        landmark_id2index(landmark_index2id(i)) = i;
    end

    global N = size(pose_index2id, 2);
    global M = size(landmark_index2id, 2);

    X = zeros(N*3+M*2, 1);
    for i=1:size(poses,2)
        % INITIALIZE POSITIONS PART OF THE STATE
        Xr = [poses(i).x; poses(i).y; poses(i).theta];
        X(i*3-2:i*3) = Xr;
    end
    for i=1:size(landmarks,2)
        Xl = [landmarks(i).x_pose; landmarks(i).y_pose];
        X(N*3+i*2-1:N*3+i*2) = Xl;
    end

    for i=1:size(observations,2)
        pose_id = observations(i).pose_id;
        land_id = observations(i).observation.id;
        range = observations(i).observation.range;
        measurements(i) = measurement(pose_id, land_id, range);
    end
    
    % Start optimization
    for i=1:n_iterations
        printf("iteration %d\n",i)
        
        [dx, chi] = solveSingleICP(X, measurements);
        chi_stats(end+1) = chi;
        X = boxPlus(X, dx);
    end

    [poses_opt, landmarks_opt] = extractPosesAndLandmarksFromState(X);
    
end