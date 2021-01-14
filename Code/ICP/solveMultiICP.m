function [poses_opt, landmarks_opt, chi_stats] = solveMultiICP(poses, landmarks, observations, n_iterations)

    new_poses = [];
    new_landmarks = [];
    for i=1:size(observations,2)
        pose_id = observations(i).pose_id;
        land_id = observations(i).observation.id;
        
        new_poses(end+1) = pose_id;
        new_landmarks(end+1) = land_id;
        
    end
    
    for i=1:size(poses, 2)
        if any(new_poses==poses(i).id)
            new_new_poses(end+1) = poses(i);
        end
    end
    for i=1:size(landmarks, 2)
        if any(new_landmarks==landmarks(i).id)
            new_new_landmarks(end+1) = landmarks(i);
        end
    end
    poses=new_new_poses
    landmarks=new_new_landmarks

    % Create mapping between indeces and IDs
    pose_index2id = zeros(1,size(poses,2));
    for i=1:size(poses,2)
        pose_index2id(i) = poses(i).id;
    end
    pose_id2index = zeros(1, pose_index2id(end));
    for i=1:size(pose_index2id, 2)
        pose_id2index(pose_index2id(i)) = i;
    end
    landmark_index2id = zeros(1,size(landmarks,2));
    for i=1:size(landmarks,2)
        landmark_index2id(i) = landmarks(i).id;
    end
    landmark_id2index = zeros(1, landmark_index2id(end));
    for i=1:size(landmark_index2id, 2)
        landmark_id2index(landmark_index2id(i)) = i;
    end
    % Start optimization
    for i=1:n_iterations
        printf("iteration %d",i)
        for i=1:size(observations,2)
            pose_id = observations(i).pose_id;
            land_id = observations(i).observation.id;
            range = observations(i).observation.range;
            measurements(i) = measurement(poses(pose_id2index(pose_id)), landmarks(landmark_id2index(land_id)), range);
        end
        
        [dx, chi] = solveSingleICP(measurements, pose_index2id, pose_id2index, landmark_index2id, landmark_id2index);
        chi_stats(end+1) = chi;
        [poses, landmarks] = applyIncrements(dx, poses, landmarks, pose_index2id, pose_id2index, landmark_index2id, landmark_id2index);
    end

    poses_opt = poses;
    landmarks_opt = landmarks;
end