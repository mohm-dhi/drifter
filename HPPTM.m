%#######################################################################
%# Created Date:    '2024-06-17'                                       #
%# Author(s):       Mohammad Madani - madanim@uwindsor.ca              #
%#                                                                     #
%# Language:        MATLAB                                             #
%# ------------------------------------------------------------------- #
%# Copyright (c) (2024) Mohammad Madani.                               #
%#######################################################################

function [x, y, ts] = HPPTM(Grid_X, Grid_Y, U, V, Time, Param)
    % HPPTM Performs particle tracking in a given velocity field.
    %
    % Syntax:
    %   [x, y, ts] = HPPTM(Grid_X, Grid_Y, U, V, Time, Param)
    %
    % Inputs:
    %   Grid_X  - X-coordinates of the grid.
    %   Grid_Y  - Y-coordinates of the grid.
    %   U       - X-component of the velocity field.
    %   V       - Y-component of the velocity field.
    %   Time    - Time vector.
    %   Param   - Structure containing tracking parameters.
    %
    % Outputs:
    %   x       - X-coordinates of the particle trajectories.
    %   y       - Y-coordinates of the particle trajectories.
    %   ts      - Time vector corresponding to the trajectories.
    %
    % Example:
    %   [x, y, ts] = HPPTM(Grid_X, Grid_Y, U, V, Time, Param);
    %

    odesolver = Param.odesolver;
    options = Param.options;
    Particle_position = Param.Particle_position;
    tspan = Param.tspan;
    Mode = Param.Mode;
    Turb = Param.Turb;

    if ~exist('odesolver', 'var')
        odesolver = 'ode45';
    end

    if ~exist('options', 'var')
        options = [];
    end

    ntraj = size(Particle_position, 1);
    y0 = [Particle_position(:,1); Particle_position(:,2)];

    if strcmpi(Mode, 'backward')
        U = -U;
        V = -V;
        U = U(:,:,end:-1:1);
        V = V(:,:,end:-1:1);
    end

    options.Events = []; % @myEventXX;

    [ts, A] = feval(odesolver, @ptrack_ode_worker_func, tspan, y0, options, ...
        Grid_X, Grid_Y, U, V, Time);

    [x, y] = deal(A(:,1:ntraj), A(:,ntraj+1:end));
end

%%%%%%----------------------Subfunctions--------------------%%%%%%%
function f = ptrack_ode_worker_func(T, y, X, Y, ux, uy, tt)
    ntraj = length(y)/2;
    [xx, yy] = deal(y(1:ntraj), y(ntraj+1:end));

    d = tt - T;
    
    if all(d < 0) || all(d > 0)
        f = repmat(NaN, size(y));
        return
    end

    dlt = max(d(d < 0));
    dgt = min(d(d >= 0));
    if dgt == 0
        [ux, uy] = deal(ux(:, :, d == 0), uy(:, :, d == 0));
    else
        ilt = d == dlt;
        igt = d == dgt;
        dd = dgt - dlt;
        clt = dgt / dd;
        cgt = -dlt / dd;
        ux = clt * ux(:, :, ilt) + cgt * ux(:, :, igt);
        uy = clt * uy(:, :, ilt) + cgt * uy(:, :, igt);
    end

    nn = ~isnan(xx) & ~isnan(yy);
    [UX, UY] = deal(repmat(NaN, size(xx)));

    UX(nn) = interp2(X, Y, ux, xx(nn), yy(nn), 'linear');
    UY(nn) = interp2(X, Y, uy, xx(nn), yy(nn), 'linear');
    f = [UX(:); UY(:)];
end
