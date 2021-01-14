function point = drawRanges(poses, observations, land_ids)
    for i=1:size(observations, 2)
        p = findPose(poses, observations(i).pose_id);
        obs = observations(i).observation;
        for j=1:size(obs, 2)
            land_id = obs(j).id;
            range_ = obs(j).range;
            if ismember(land_id, land_ids)
                circle(p.x, p.y, range_);
            end
        end
    end
end