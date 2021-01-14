function pose = findPose(poses, id)
    for i=1:size(poses, 2)
        if poses(i).id==id
            pose=poses(i);
            break
        end
    end
end
