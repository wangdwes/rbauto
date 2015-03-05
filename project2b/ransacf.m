
function [bestf, inliers] = ransacf(locs1, locs2, maxiter, tol)

  % such that the returning arguments are always assigned. 
  matchcount = size(locs1, 1);
  inliers = false(matchcount, 1); bestf = diag([1 1 0]);

  for index = 1: maxiter,

    % randomly sample eight point pairs (correspondences) each time,
    % and compute the corresponding fundamental matrix.  
    selected = randperm(matchcount, 8);
    f = fundamat(locs1(selected, :), locs2(selected, :)); 

    % compute the sampson distances (first-order geometric error) as our error metrics.
    % note that the third column of locs1 and locs2 should always be one.  
    pd1 = locs1 * f'; pd2 = locs2 * f; 
    dists = sum(locs2 * f .* locs1, 2) .^ 2 ./ ...
      (pd1(:, 1) .^ 2 + pd1(:, 2) .^ 2 + ... 
       pd2(:, 1) .^ 2 + pd2(:, 2) .^ 2); 

    % if there're more inliers and previously stored, take it. 
    if sum(inliers) < sum(dists < tol), 
      inliers = dists < tol; 
    end

  end 

  bestf = fundamat(locs1(inliers, :), locs2(inliers, :)); 
  % the model may be improved by re-restimating it
  % using all members of the consensus set.

end
