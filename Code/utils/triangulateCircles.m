function point = triangulateCircles(centers, radii)

    error_func = createErrorFunction(centers, radii);

    options = optimset('MaxIter', 1000);
    point = fminsearch(error_func, [0,0]);
end