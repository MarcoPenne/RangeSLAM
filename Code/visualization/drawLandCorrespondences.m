function [] = drawLandCorrespondences(l_gt, l_opt)

    l_gt
    l_opt
    hold on
    for i=1:size(l_opt, 2)
        for j=1:size(l_gt, 2)
            if l_opt(i).id == l_gt(j).id
                plot([l_opt(i).x_pose l_gt(i).x_pose], [l_opt(i).y_pose l_gt(i).y_pose], 'Color','#AAAAAA', 'LineStyle', ':' )
            end
        end
    end

end