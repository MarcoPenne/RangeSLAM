function landmark = findLandmark(landmarks, id)
    for i=1:size(landmarks, 2)
        if landmarks(i).id==id
            landmark=landmarks(i);
            break
        end
    end
end
