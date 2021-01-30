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
        pose_id = measurements(i).pose_id;
        land_id = measurements(i).landmark_id;
        if landmark_id2index(land_id)~=0
            [e, Jr, Jl] = errorAndJacobianMeasurement(X, measurements(i));
            

            chi = e'*e;
            chi_tot = chi_tot + chi;
            value = 2 * exp(0.2*(iteration-10));
            if value>4
                value=4;
            end
            O = value;
            H(pose_id2index(pose_id)*3 - 2 : pose_id2index(pose_id)*3, pose_id2index(pose_id)*3 - 2 : pose_id2index(pose_id)*3) += Jr'*O*Jr;
            H(pose_id2index(pose_id)*3 - 2 : pose_id2index(pose_id)*3, 3*N + landmark_id2index(land_id)*2-1: 3*N + landmark_id2index(land_id)*2) += Jr'*O*Jl;
            H(3*N + landmark_id2index(land_id)*2-1: 3*N + landmark_id2index(land_id)*2, pose_id2index(pose_id)*3 - 2 : pose_id2index(pose_id)*3) += Jl'*O*Jr;
            H(3*N + landmark_id2index(land_id)*2-1: 3*N + landmark_id2index(land_id)*2, 3*N + landmark_id2index(land_id)*2-1: 3*N + landmark_id2index(land_id)*2) += Jl'*O*Jl;
            b(pose_id2index(pose_id)*3 - 2 : pose_id2index(pose_id)*3) += Jr'*O*e;
            b(3*N + landmark_id2index(land_id)*2-1: 3*N + landmark_id2index(land_id)*2) += Jl'*O*e;
            
        end    
        
        %val_image(pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2, pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2)=ones(2,2);
        %val_image(2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2, 2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2) = ones(2,2);
    end

    for i=1:size(transitions, 2)
        [e, Ji, Jj] = errorAndJacobianTransition(X, transitions(i));
        pose_id_i = transitions(i).id_from;
        pose_id_j = transitions(i).id_to;
        
        chi = e'*e;
        chi_tot = chi_tot + chi;
        value = 2 * exp(-0.2*(iteration-1));
        %if value<0.3
        %    value=0;
        %end
        O = value * eye(3);
        H(pose_id2index(pose_id_i)*3 - 2 : pose_id2index(pose_id_i)*3, pose_id2index(pose_id_i)*3 - 2 : pose_id2index(pose_id_i)*3) += Ji'*O*Ji;
        H(pose_id2index(pose_id_i)*3 - 2 : pose_id2index(pose_id_i)*3, pose_id2index(pose_id_j)*3 - 2 : pose_id2index(pose_id_j)*3) += Ji'*O*Jj;
        H(pose_id2index(pose_id_j)*3 - 2 : pose_id2index(pose_id_j)*3, pose_id2index(pose_id_i)*3 - 2 : pose_id2index(pose_id_i)*3) += Jj'*O*Ji;
        H(pose_id2index(pose_id_j)*3 - 2 : pose_id2index(pose_id_j)*3, pose_id2index(pose_id_j)*3 - 2 : pose_id2index(pose_id_j)*3) += Jj'*O*Jj;
        b(pose_id2index(pose_id_i)*3 - 2 : pose_id2index(pose_id_i)*3) += Ji'*O*e;
        b(pose_id2index(pose_id_j)*3 - 2 : pose_id2index(pose_id_j)*3) += Jj'*O*e;
    end
    H(1:3, 1:3) += eye(3)*large_value;
    %image = H==0;
    %det(H)
    %figure();
    %imshow(val_image)
    %figure();
    %imshow(image)
    dx = -H\b;
    dx = 0.1*dx;
    %dx = 0

end