%#######################################################################
%# Created Date:    '2024-06-17'                                       #
%# Author(s):       Mohammad Madani - madanim@uwindsor.ca              #
%#                                                                     #
%# Language:        MATLAB                                             #
%# ------------------------------------------------------------------- #
%# Copyright (c) (2024) Mohammad Madani.                               #
%#######################################################################

clc
clf
kill

Animation = 1;   % 0 No Animation, 1 Yes Animation and create movie
VideoOUT = 0;    % 0 No Video File output, 1 Yes Video Output in the same directory

% Domain location to get information
minI = 225;
maxI = 235;
minJ = 85;
maxJ = 89;

Y = ncread('SHEET_AVEG_200m_All_Var.nc', 'Y'); % Y values extracted from a SHEET file
X = ncread('SHEET_AVEG_200m_All_Var.nc', 'X'); % X values extracted from a SHEET file
BATH = ncread('SHEET_AVEG_200m_All_Var.nc', 'BATH'); % Bath values extracted from a SHEET file
P = sanePColor(Y', X', BATH);
shading flat
colormap gray
set(gca, 'Ydir', 'reverse')
hold on

DATAX = ncread('DRIFTER_DATA.nc', 'DRIFTER_X'); % X location of Drifters
DATAY = ncread('DRIFTER_DATA.nc', 'DRIFTER_Y'); % Y location of Drifters

Year = ncread('DRIFTER_DATA.nc', 'Year');
Month = ncread('DRIFTER_DATA.nc', 'Month');
Day = ncread('DRIFTER_DATA.nc', 'Day');
Hour = ncread('DRIFTER_DATA.nc', 'Hour');
Minute = ncread('DRIFTER_DATA.nc', 'Minute');
Second = ncread('DRIFTER_DATA.nc', 'Second');

DX = X(2) - X(1);
DY = Y(2) - Y(1);
iX = floor(DATAX / DX) + 1;
jY = floor(DATAY / DY) + 1;

[indx, ~, ~] = find(iX >= minI & iX <= maxI & jY >= minJ & jY <= maxJ);
indx = unique(indx);
Percntage = length(indx) / size(DATAX, 1) * 100;

plot([minJ maxJ] * DY, [minI minI] * DX, 'b', 'LineWidth', 2)
set(gca, 'Ydir', 'reverse')
plot([minJ maxJ] * DY, [maxI maxI] * DX, 'b', 'LineWidth', 2)
plot([minJ minJ] * DY, [minI maxI] * DX, 'b', 'LineWidth', 2)
plot([maxJ maxJ] * DY, [minI maxI] * DX, 'b', 'LineWidth', 2)

if Animation == 1
    N = 1;
else
    N = size(DATAX, 1);
end

color = jet(size(DATAX, 1));

for i = 1:N
    if Animation == 1
        for k = 1:size(DATAX, 1)
            curve(k) = animatedline('LineWidth', 1, 'Color', color(k, :));
        end
        for j = 1:20:size(DATAX, 2)
            Box_Check = 1;
            for k = 1:size(DATAX, 1)
                addpoints(curve(k), DATAY(k, j), DATAX(k, j), 0);
            end
            head = scatter(DATAY(:, j), DATAX(:, j), 4, color, 'filled');
            TEXT = {[num2str(Year(j)), '-', month2name(Month(j)), '-', sprintf('%02d', Day(j))]; ...
                    [sprintf('%02d', Hour(j)), ':', sprintf('%02d', Minute(j)), ':', ...
                    sprintf('%02d', round(Second(j)))]};

            dim = [0.15 0.6 0.3 0.3];
            XX = annotation('textbox', dim, 'String', TEXT);
            XX.Color = 'b';
            XX.FitBoxToText = 'on';

            set(gca, 'Ydir', 'reverse')
            drawnow
            F(j) = getframe(gcf);
            % pause(0);
            if j < size(DATAX, 2)
                delete(head);
                delete(XX);
                Box_Check = 0;
            end
        end
        
        if Box_Check == 0
            dim = [0.15 0.6 0.3 0.3];
            XX = annotation('textbox', dim, 'String', TEXT);
            XX.Color = 'b';
            XX.FitBoxToText = 'on';
        end
        
    else
        plot(DATAY(i, :), DATAX(i, :), 'Color', color(i, :))
        set(gca, 'Ydir', 'reverse')   % to inverse the Y axis
    end
end

if (Animation == 1 && VideoOUT == 1)
    video = VideoWriter('Animation_OUT.avi', 'MPEG-4');
    video.FrameRate = 60;
    open(video)
    writeVideo(video, F)
    close(video)
end
