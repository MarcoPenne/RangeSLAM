function point = drawPoses(poses, color)
    %plot poses

    for i=1:size(poses, 2)
        xes(end+1) = poses(i).x;
        yes(end+1) = poses(i).y;
    end
    
    hold on
    
    point = plot(xes, yes, color, "linewidth", 2);
    plot([xes], [yes], color(1:1));
        
    %for i=1:size(poses, 2)
    %    hold on;
    %    if i~=1
    %        plot([last.x, poses(i).x], [last.y, poses(i).y], 'r')
    %    end
    %    last = poses(i);
    %end
end