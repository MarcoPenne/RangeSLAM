function [poses, landmarks] = extractPosesAndLandmarksFromState(X)

    global N M;
    global pose_index2id landmark_index2id;

    for i=1:N
        poses(end+1) = pose(pose_index2id(i), X(i*3-2), X(i*3-1), X(i*3));
    end
    for i=1:M
        landmarks(end+1) = landmark(landmark_index2id(i), [X(3*N+i*2-1) X(3*N+i*2)]);
    end
    


end