function [dx, chi_tot] = solveSingleICP(X, measurements)

    global pose_index2id pose_id2index landmark_index2id landmark_id2index
    global N;
    global M;

    H = zeros(N*3+M*2, N*3+M*2);
    b = zeros(N*3+M*2, 1);

    kernel_threshold = 10000000;
    chi_tot = 0;
    val_image = zeros(N*3+M*2, N*3+M*2);
    for i=1:size(measurements, 2)
        %printf("Processing measurement %d\n", i);
        [e, J] = errorAndJacobian(X, measurements(i));
        
        chi = e'*e;
        if (chi>kernel_threshold)
      	    e*=sqrt(kernel_threshold/chi);
      	    chi=kernel_threshold;
            chi_tot = chi_tot + chi;
            O = 1;
            H = H + J'*O*J;
            b = b + J'*O*e;
        else
            chi_tot = chi_tot + chi;
            O = 1;
            H = H + J'*O*J;
            b = b + J'*O*e;
        end
        

        %measurements(i)
        %val_image(pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2, pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2)=ones(2,2);
        %val_image(2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2, 2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2) = ones(2,2);
    end
    %image = H~=0;
    %det(H)
    %figure();
    %imshow(val_image)
    %figure();
    %imshow(image)
    dx = -H\b;
    %dx = 0

end