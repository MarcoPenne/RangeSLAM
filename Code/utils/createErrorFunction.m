function f = createErrorFunction(centers, radii)

    f= @(x) 0;
    for i=1:size(radii)
        plus =  @(x) (norm(x-[centers(i, 1) centers(i, 2)]) - radii(i))^2;
        f = @(x) f(x) + plus(x);
    end

end