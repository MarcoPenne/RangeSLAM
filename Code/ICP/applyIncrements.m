function [poses, landmarks] = applyIncrements(dx, poses, landmarks, pose_index2id, pose_id2index, landmark_index2id, landmark_id2index)

    N = size(pose_index2id, 2);
    M = size(landmark_index2id, 2);

    for i=1:N
        poses(i).x = poses(i).x + dx(2*i-1);
        poses(i).y = poses(i).y + dx(2*i);
    end
    for i=1:M
        landmarks(i).x_pose = landmarks(i).x_pose + dx(2*N + 2*i-1);
        landmarks(i).y_pose = landmarks(i).y_pose + dx(2*N + 2*i);
    end

end