function point = LS_triangulateCircles(centers, radii)

    % error_func = createErrorFunction(centers, radii);

    % options = optimset('MaxIter', 1000);
    [radius_max, index_max] = max(radii);
    center_max = centers(index_max, :);
    %point_max = fminsearch(error_func, center_max);
    [radius_min, index_min] = min(radii);
    center_min = centers(index_min, :);
    % point_min = fminsearch(error_func, center_min);
    % if error_func(point_min) <= error_func(point_max)
    %     point = point_min;
    % else
    %     point = point_max;
    % end

    n_it=30;
    X = center_min';
    for i=1:n_it
        H = zeros(2, 2);
        b = zeros(2, 1);
        chi_min = 0;
        for i=1:size(centers,1)
            xc = centers(i,1);
            yc = centers(i,2);
            C = [xc; yc];
            r = radii(i);
            if norm(X - C)>0
                e = norm(X - C) - radii(i);
                J = [(-xc+X(1))/norm(X - C),  (-yc+X(2))/norm(X - C)];

                H = H + J'*J;
                b = b + J'*e;
                chi_min = chi_min + e'*e;
            else
                e = norm(X - C) - radii(i);
                J = [1000,  1000];

                H = H + J'*J;
                b = b + J'*e;
                chi_min = chi_min + e'*e;
                
            end
        end
        dx = -H\b;
        dx = dx;
        X = X+dx;
    end
    X_min = X;

    %if chi_min < chi_max
        point = X_min';
    %else
    %    point = X_max';
    %end
end