function [point, valid] = LS_triangulateCircles(centers, radii, threshold)
    
    point = [0, 0];
    enought_dofs = centers;
    dm = distanceMatrix(centers, radii);
    
    to_eliminate = [];
    for i=1:size(centers, 1)
        for j=(i+1):size(centers, 1)

            % these two circles are too similar
            if dm(i, j) < threshold
                to_eliminate(end+1) = i;
            end
        end
    end
    
    enought_dofs(to_eliminate, :) = [];
    
    valid = true;
    if size(enought_dofs, 1) < 3
        valid = false;
        return
    end

    [radius_min, index_min] = min(radii);
    center_min = centers(index_min, :);
    
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
    
    point = X';

end