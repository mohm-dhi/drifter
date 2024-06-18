%#######################################################################
%# Created Date:    '2024-06-17'                                       #
%# Author(s):       Mohammad Madani - madanim@uwindsor.ca              #
%#                                                                     #
%# Language:        MATLAB                                             #
%# ------------------------------------------------------------------- #
%# Copyright (c) (2024) Mohammad Madani.                               #
%#######################################################################

clear
clc
close all
kill

% Path_to_ncfile='D:\PhD_project\ELCD\ELCD-Projects\StClair\2016\run_200\unffiles\SHEET_AVEG_200m_All_Var.nc';
Path_to_ncfile = 'D:\PhD_project\AEM3D\Windows_64\Models_Run\test\RoundLake\run\ncfiles\sheet_avg.nc';
INFO = ncinfo(Path_to_ncfile);

if ~exist('model_input.mat', 'file')
    DATA = read_netcdf(Path_to_ncfile);
    save model_input.mat
else 
    load model_input.mat
end

Date = DATA.Ordinal_Dates;
% T=(Date(2)-Date(1))*86400;
X = DATA.X;
Y = DATA.Y;
BATH = permute(DATA.BATH, [2 1]);
BATH(BATH == DATA.BATH__FillValue) = nan;
DX = DATA.DX_i;
DY = DATA.DY_j;
% [GRID_X,GRID_Y]=meshgrid(cumsum(DX),cumsum(DY));
[GRID_Y, GRID_X] = meshgrid(Y, X);

% GRID_X(isnan(BATH)) = nan;
% GRID_Y(isnan(BATH)) = nan;
U = permute(DATA.U_VELOCITY, [3 2 1]);
V = permute(DATA.V_VELOCITY, [3 2 1]);
U(U == DATA.U_VELOCITY__FillValue) = nan;
V(V == DATA.V_VELOCITY__FillValue) = nan;

Param.Mode = 'Forward'; % use 'Backward' for Backward tracking module
Param.Turb = 'Flase'; % use 'T' or 'True' for Turbulence module based on
                      % random walk or random displacement method (RDM)
Param.avoidcosat = 0;                        
Param.IntrapolationMethod = 'linear';                        
Param.Particle_position = readtable('Particle_Position_Release_sandpoint2.xlsx');
Param.Particle_position = readtable('Particle_Position_Release_test.xlsx');

if ~exist('odesolver', 'var')
    Param.odesolver = 'ode45';
end

if ~exist('options', 'var')
    Param.options = [];
end

DateNUM = datenum(double([DATA.Year, DATA.Month, DATA.Day, ...
    DATA.Hour, DATA.Minute, DATA.Second]));
Date = (DateNUM - DateNUM(1)) * 86400;
Param.tspan = Date(1) : 3600 : Date(end);
Param.DateNUM = DateNUM;

% Get some good option values for tracking - otherwise output is junk.
abs_tol = 1.0e-5; % Not sure about this
rel_tol = 1.0e-5; % Not sure about this
maxstep = 3600; % 1/4 hour  
Param.options = odeset('RelTol', rel_tol, 'AbsTol', abs_tol, 'MaxStep', maxstep, 'Refine', 2);

[x, y, ts] = HPPTM(GRID_X, GRID_Y, U, V, Date, Param);
size(x)

%% Plot Section
figure;
h = pcolor(GRID_Y, GRID_X, U(:,:,1));
set(gca, 'Ydir', 'reverse')
set(h, 'EdgeColor', 'none');
colormap jet
colorbar

hold on

for i = 1:size(x, 2)
    comet(y(:,i), x(:,i))
end
