function [dx, chi_tot] = solveSingleICP(X, measurements, transitions, iteration)

    global pose_index2id pose_id2index landmark_index2id landmark_id2index
    global N;
    global M;

    H = zeros(N*3+M*2, N*3+M*2);
    b = zeros(N*3+M*2, 1);
    large_value = 1e9;

    kernel_threshold = 10;
    chi_tot = 0;
    val_image = zeros(N*3+M*2, N*3+M*2);
    for i=1:size(measurements, 2)
        %printf("Processing measurement %d\n", i);
        [e, J] = errorAndJacobianMeasurement(X, measurements(i));
        
        chi = e'*e;
        chi_tot = chi_tot + chi;
        value = 2 * exp(0.2*(iteration-10));
        if value>4
            value=4;
        end
        O = value;
        H = H + J'*O*J;
        b = b + J'*O*e;
        
        %H(1:3, 1:3) = eye(3)*large_value;
        
        %val_image(pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2, pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2)=ones(2,2);
        %val_image(2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2, 2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2) = ones(2,2);
    end

    for i=1:size(transitions, 2)
        [e, J] = errorAndJacobianTransition(X, transitions(i));
        
        chi = e'*e;
        chi_tot = chi_tot + chi;
        value = 2 * exp(-0.2*(iteration-1));
        %if value<0.3
        %    value=0;
        %end
        O = value * eye(3);
        H = H + J'*O*J;
        b = b + J'*O*e;
    end
    %image = H~=0;
    %det(H)
    %figure();
    %imshow(val_image)
    %figure();
    %imshow(image)
    dx = -H\b;
    dx = 0.1*dx;
    %dx = 0

end