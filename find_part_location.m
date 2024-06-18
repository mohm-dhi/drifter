%#######################################################################
%# Created Date:    '2024-06-17'                                       #
%# Author(s):       Mohammad Madani - madanim@uwindsor.ca              #
%#                                                                     #
%# Language:        MATLAB                                             #
%# ------------------------------------------------------------------- #
%# Copyright (c) (2024) Mohammad Madani.                               #
%#######################################################################

function [ii, jj] = find_part_location(X, Y, xx, yy)
    % FIND_PART_LOCATION Finds the nearest indices in X and Y to the given points xx and yy.
    %
    % Syntax:
    %   [ii, jj] = find_part_location(X, Y, xx, yy)
    %
    % Inputs:
    %   X  - A matrix representing the grid points in the x-direction.
    %   Y  - A matrix representing the grid points in the y-direction.
    %   xx - A scalar value representing the x-coordinate of the point to locate.
    %   yy - A scalar value representing the y-coordinate of the point to locate.
    %
    % Outputs:
    %   ii - The index in X corresponding to the nearest x-coordinate to xx.
    %   jj - The index in Y corresponding to the nearest y-coordinate to yy.
    %
    % Example:
    %   [ii, jj] = find_part_location(X, Y, xx, yy);
    %

    ii = knnsearch(X(:,1), xx);
    jj = knnsearch(Y(1,:)', yy);
end
