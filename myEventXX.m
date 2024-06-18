%#######################################################################
%# Created Date:    '2024-06-17'                                       #
%# Author(s):       Mohammad Madani - madanim@uwindsor.ca              #
%#                                                                     #
%# Language:        MATLAB                                             #
%# ------------------------------------------------------------------- #
%# Copyright (c) (2024) Mohammad Madani.                               #
%#######################################################################

function [value, isterminal, direction] = myEventXX(~, y0)
    % MYEVENTXX Event function for ODE solver to stop integration based on a condition.
    %
    % Syntax:
    %   [value, isterminal, direction] = myEventXX(~, y0)
    %
    % Inputs:
    %   ~   - Placeholder for time variable, not used in this function.
    %   y0  - State vector at the current time step.
    %
    % Outputs:
    %   value      - Condition value for the event function.
    %   isterminal - Boolean indicating whether the integration should stop.
    %   direction  - Direction of zero-crossing that the event function detects.
    %
    % Example:
    %   options = odeset('Events', @myEventXX);
    %   [t, y] = ode45(@odefun, tspan, y0, options);
    %

    value = all(isnan(y0) == 1) - 0.5;
    isterminal = 1; % Stop the integration
    direction = 0;
end
