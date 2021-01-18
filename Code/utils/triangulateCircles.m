function point = triangulateCircles(centers, radii)

    error_func = createErrorFunction(centers, radii);

    options = optimset('MaxIter', 1000);
    [radius_max, index_max] = max(radii);
    center_max = centers(index_max, :);
    point_max = fminsearch(error_func, center_max);
    [radius_min, index_min] = min(radii);
    center_min = centers(index_min, :);
    point_min = fminsearch(error_func, center_min);
    if error_func(point_min) <= error_func(point_max)
        point = point_min;
    else
        point = point_max;
    end

    % x_len=size(center_min(1)-radius_max:0.01:center_min(1)+radius_max, 2);
    % final_grid = zeros(x_len, x_len);
    % for x=1:x_len
    %     for y=1:x_len
    %         final_grid(x, y) = error_func([center_min(1)-radius_max + 0.01*x, center_min(2)-radius_max + 0.01*y]);
    %     end
    % end
    %error_func([0,2])
    %imregionalmin(final_grid)
    %[radius, index] = min(radii);
    %point_center = centers(index, :);
    %point = 0.95*point_center + 0.05*point;
end