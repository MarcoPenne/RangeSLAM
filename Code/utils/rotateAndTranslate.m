function [poses, landmarks] = rotateAndTranslate(poses, landmarks)

    v = [poses(1).x; poses(1).y; poses(1).theta];

    v = v2t(v);
    T = t_inverse(v);
    T2 = v2t([-0.009456; 0.021667; -0.007264]);
    T = T2*T;

    for i=1:size(poses, 2)
        v = [poses(i).x; poses(i).y; poses(i).theta];
        v = v2t(v);
        v = t2v(T*v);
        poses(i).x = v(1);
        poses(i).y = v(2);
        poses(i).theta = v(3);
    end
    for i=1:size(landmarks, 2)
        v = [landmarks(i).x_pose; landmarks(i).y_pose; 1];
        v = T*v;
        landmarks(i).x_pose = v(1);
        landmarks(i).y_pose = v(2);
    end
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
