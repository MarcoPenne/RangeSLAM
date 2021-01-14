function [e, J] = errorAndJacobian(measurement, pose_index2id, pose_id2index, landmark_index2id, landmark_id2index)

    N = size(pose_index2id, 2);
    M = size(landmark_index2id, 2);

    x_l = measurement.landmark.x_pose;
    y_l = measurement.landmark.y_pose;
    x_r = measurement.pose_r.x;
    y_r = measurement.pose_r.y;

    h = norm([x_r; y_r] - [x_l; y_l]);
    e = h - measurement.obs;
    
    J = zeros(1, 2*N+2*M);
    J(pose_id2index(measurement.pose_r.id)*2 -1:pose_id2index(measurement.pose_r.id)*2) = double([(-x_l+x_r)/h (-y_l+y_r)/h]);
    J(2*N + landmark_id2index(measurement.landmark.id)*2-1: 2*N + landmark_id2index(measurement.landmark.id)*2) = double([(x_l-x_r)/h (y_l-y_r)/h]);
end