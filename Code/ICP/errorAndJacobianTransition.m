function [e, Ji, Jj] = errorAndJacobianTransition(X, transition)

    global pose_index2id pose_id2index
    global N;
    global M;

    pose_id_i = transition.id_from;
    pose_id_j = transition.id_to;
    z = transition.v;
    
    x_ri = X(pose_id2index(pose_id_i)*3-2);
    y_ri = X(pose_id2index(pose_id_i)*3-1);
    theta_ri = X(pose_id2index(pose_id_i)*3);

    x_rj = X(pose_id2index(pose_id_j)*3-2);
    y_rj = X(pose_id2index(pose_id_j)*3-1);
    theta_rj = X(pose_id2index(pose_id_j)*3);

    Z = v2t(z);
    e = t2v(t_inverse(Z) * t_inverse(v2t([x_ri; y_ri; theta_ri])) * v2t([x_rj; y_rj; theta_rj]));

    Jj = [cos(theta_ri + z(3))  sin(theta_ri + z(3))  x_rj*sin(theta_ri + z(3))-y_rj*cos(theta_ri + z(3));
        -sin(theta_ri + z(3))  cos(theta_ri + z(3))  x_rj*cos(theta_ri + z(3))+y_rj*sin(theta_ri + z(3));
        0  0  1];
    Ji = -Jj;

    %J = zeros(3, 3*N+2*M);
    %J(1:3, pose_id2index(pose_id_i)*3 - 2 : pose_id2index(pose_id_i)*3) = Ji;
    %J(1:3, pose_id2index(pose_id_j)*3 - 2 : pose_id2index(pose_id_j)*3) = Jj;
end

function t = v2t(X)
    t = zeros(3,3);
    t(1:2, 3) = X(1:2);
    t(3, 3) = 1;
    theta = X(3);
    t(1:2, 1:2) = [cos(theta) -sin(theta);sin(theta) cos(theta)];
end

function v = t2v(t)
    v = zeros(3,1);
    v(1:2) = t(1:2, 3);
    v(3) = atan2(t(2,1), t(1,1));
end

function i = t_inverse(t)
    i = zeros(3,3);
    i(3, 3) = 1;
    i(1:2, 3) = -t(1:2, 1:2)' * t(1:2, 3);
    i(1:2, 1:2) = t(1:2, 1:2)';
end
