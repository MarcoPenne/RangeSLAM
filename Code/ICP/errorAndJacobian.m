function [e, J] = errorAndJacobian(X, measurement)

    global pose_index2id pose_id2index landmark_index2id landmark_id2index
    global N;
    global M;

    pose_id = measurement.pose_id;
    land_id = measurement.landmark_id;
    x_l = X(3*N + landmark_id2index(land_id)*2-1);
    y_l = X(3*N + landmark_id2index(land_id)*2);
    x_r = X(pose_id2index(pose_id)*3-2);
    y_r = X(pose_id2index(pose_id)*3-1);

    h = norm([x_r; y_r] - [x_l; y_l]);
    e = h - measurement.obs;
    
    J = zeros(1, 3*N+2*M);
    J(pose_id2index(pose_id)*3 - 2 : pose_id2index(pose_id)*3) = double([(-x_l+x_r)/h (-y_l+y_r)/h 0]);
    J(3*N + landmark_id2index(land_id)*2-1: 3*N + landmark_id2index(land_id)*2) = double([(x_l-x_r)/h (y_l-y_r)/h]);
end