%#######################################################################
%# Created Date:    '2024-06-17'                                       #
%# Author(s):       Mohammad Madani - madanim@uwindsor.ca              #
%#                                                                     #
%# Language:        MATLAB                                             #
%# ------------------------------------------------------------------- #
%# Copyright (c) (2024) Mohammad Madani.                               #
%#######################################################################

function LC = count_land_cell(i, j, ux, uy)
    % count_land_cell Counts the land cells around the given coordinates.
    %
    % Syntax:
    %   LC = count_land_cell(i, j, ux, uy)
    %
    % Inputs:
    %   i  - A vector of x-coordinates.
    %   j  - A vector of y-coordinates.
    %   ux - A matrix representing the x-component of the velocity field.
    %   uy - A matrix representing the y-component of the velocity field.
    %
    % Outputs:
    %   LC - A vector of the minimum count of land cells around each coordinate.
    %
    % Example:
    %   LC = count_land_cell(i, j, ux, uy);
    %

    indx = repmat(1:3, size(i,1), 1) + repmat(3 * (0:(size(i,1) - 1))', 1, 3) + ...
        repmat(size(i,1) * 3 * (0:(size(i,1) - 1))', 1, 3);
    Ux_neighbor = [];
    Uy_neighbor = [];
    for c = -1:1:1
        iix = [i + c];
        jjx = [j - 1 j j + 1]';
        Un = ux(iix, jjx)';
        Un = Un(indx);
        Ux_neighbor = [Ux_neighbor Un];
        Un = uy(iix, jjx)';
        Un = Un(indx);
        Uy_neighbor = [Uy_neighbor Un];
    end
    Ux_neighbor = reshape(Ux_neighbor', 3, 3, size(i, 1));
    Ux_neighbor = permute(Ux_neighbor, [2 1 3]);
    Ux_neighbor(2,2,:) = nan;
    LCx = sum(sum(~isnan(Ux_neighbor), 2));
    LCx = permute(LCx, [3, 2, 1]);

    Uy_neighbor = reshape(Uy_neighbor', 3, 3, size(i, 1));
    Uy_neighbor = permute(Uy_neighbor, [2 1 3]);
    Uy_neighbor(2,2,:) = nan;
    LCy = sum(sum(~isnan(Uy_neighbor), 2));
    LCy = permute(LCy, [3, 2, 1]);
    LC = min([LCx LCy], [], 2);
end
