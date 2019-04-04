function tracks = predictNewLocationsOfTracks(tracks)
        for i=1:length(tracks)
            predictedCentroid = predict(tracks(i).kalmanFilter);
            tracks(i).x = predictedCentroid(1);
            tracks(i).y = predictedCentroid(2);
        end
end