function [dx, chi_tot] = solveSingleICP(measurements, pose_index2id, pose_id2index, landmark_index2id, landmark_id2index)

    N = size(pose_index2id, 2);
    M = size(landmark_index2id, 2);

    H = zeros(N*2+M*2, N*2+M*2);
    b = zeros(N*2+M*2, 1);

    kernel_threshold = 1000;
    chi_tot = 0;
    val_image = zeros(N*2+M*2, N*2+M*2);
    for i=1:size(measurements, 2)
        [e, J] = errorAndJacobian(measurements(i), pose_index2id, pose_id2index, landmark_index2id, landmark_id2index);
        
        chi = e'*e;
        if (chi>kernel_threshold)
      	    e*=sqrt(kernel_threshold/chi);
      	    chi=kernel_threshold;
        else
        chi_tot = chi_tot + chi;
        O = 1;
        H = H + J'*O*J;
        b = b + J'*O*e;

        %measurements(i)
        val_image(pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2, pose_id2index(measurements(i).pose_r.id)*2-1:pose_id2index(measurements(i).pose_r.id)*2)=ones(2,2);
        val_image(2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2, 2*N + landmark_id2index(measurements(i).landmark.id)*2-1: 2*N + landmark_id2index(measurements(i).landmark.id)*2) = ones(2,2);
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