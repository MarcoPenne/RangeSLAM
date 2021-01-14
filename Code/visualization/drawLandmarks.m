function point = drawLandmarks(landmarks, color)
    %plot poses

    for i=1:size(landmarks, 2)
        hold on;
        point = plot(landmarks(i).x_pose, landmarks(i).y_pose, color, "linewidth", 2);
    end
end