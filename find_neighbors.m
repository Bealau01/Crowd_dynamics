function [neighbors,Nstar,r] = find_neighbors(x, y, xi, N)
    % Finds the N closest neighbors (followers and leaders)
    % x -> follower positions
    % y -> leader positions
    % xi -> position of the point from which distances are calculated

    pos = [x; y];  % Concatenate positions (both followers and leaders)
    dists = vecnorm(pos - xi, 2, 2);  % Euclidean distances (2-norm, row-wise)
    [sorted_dist, idx] = sort(dists);  % Sort by increasing distance
    num_available = length(idx) - 1;  % Exclude self
    num_neighbors = min(N, num_available);  % Adjust if fewer than N available

    neighbors = idx(2 : 1 + num_neighbors); % Indices of the neighbors
    if num_neighbors > 0
        r = sorted_dist(1 + num_neighbors);
    else
        r = 0;
    end

    Nstar = sum(dists > 0 & dists <= r);  % Exclude xi itself
end
