function landmarks = LS_landmarks_initialization(poses, observations, threshold)
    %landmark(id,[x_pose,y_pose]);
    circles = cell(1, 297);
    for i=1:size(observations, 2)
        p = findPose(poses, observations(i).pose_id);
        obs = observations(i).observation;
        land_id = obs.id;
        range_ = obs.range;
        c_info = [p.x p.y range_];
        actual_info = cell2mat(circles(land_id));
        if size(actual_info, 1)==1 && size(actual_info, 2)==1
            circles(land_id) = [p.x p.y range_];
        else
            circles(land_id) = [actual_info; p.x p.y range_];
        end
    end

    for i=1:size(circles, 2)
        info_circles = cell2mat(circles(i));
        if size(info_circles, 2)==3
            [landmark_init, valid] = LS_triangulateCircles(info_circles(:, 1:2), info_circles(:, 3), threshold);
            if valid
                landmarks(end+1) = landmark(i,landmark_init);
            end
        end
    end
end