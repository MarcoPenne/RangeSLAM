function dm = distanceMatrix(centers, radii)
    centers = [centers radii];
    dm = zeros(size(centers, 1), size(centers, 1));
    for i=1:size(centers, 1)
        for j=i:size(centers, 1)
            d = norm(centers(i, :)' - centers(j, :)');
            dm(i, j) = d;
            dm(j, i) = d;

        end
    end

end