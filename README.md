# drifter
# MATLAB Scripts for Environmental Data Analysis and Particle Tracking

## Overview

This repository contains a collection of MATLAB scripts and functions developed by Mohammad Madani. These scripts are primarily used for environmental data analysis, particle tracking, and visualization. The repository includes functions for reading netCDF files, performing particle tracking, and creating animations of particle movements. 

## Files

1. **find_part_location.m**
    - Finds the nearest indices in X and Y to the given points xx and yy.
    - **Usage**: 
        ```matlab
        [ii, jj] = find_part_location(X, Y, xx, yy)
        ```

2. **Count_Land_Cell.m**
    - Counts the land cells around the given coordinates.
    - **Usage**: 
        ```matlab
        LC = Count_Land_Cell(i, j, ux, uy)
        ```

3. **MainScript.m**
    - The main script for reading netCDF files, setting parameters, and running particle tracking.
    - **Usage**: 
        ```matlab
        Run the script directly in MATLAB.
        ```

4. **myEventXX.m**
    - Event function for ODE solver to stop integration based on a condition.
    - **Usage**: 
        ```matlab
        [value, isterminal, direction] = myEventXX(~, y0)
        ```

5. **HPPTM.m**
    - Performs particle tracking in a given velocity field.
    - **Usage**: 
        ```matlab
        [x, y, ts] = HPPTM(Grid_X, Grid_Y, U, V, Time, Param)
        ```

6. **AnimationScript.m**
    - Script for creating animations of particle movements and optionally saving them as video files.
    - **Usage**: 
        ```matlab
        Run the script directly in MATLAB.
        ```

## Usage

1. **find_part_location.m**
    ```matlab
    [ii, jj] = find_part_location(X, Y, xx, yy);
    ```
    - Inputs:
        - `X` : Matrix representing the grid points in the x-direction.
        - `Y` : Matrix representing the grid points in the y-direction.
        - `xx`: Scalar value representing the x-coordinate of the point to locate.
        - `yy`: Scalar value representing the y-coordinate of the point to locate.
    - Outputs:
        - `ii`: Index in X corresponding to the nearest x-coordinate to xx.
        - `jj`: Index in Y corresponding to the nearest y-coordinate to yy.

2. **Count_Land_Cell.m**
    ```matlab
    LC = Count_Land_Cell(i, j, ux, uy);
    ```
    - Inputs:
        - `i`  : Vector of x-coordinates.
        - `j`  : Vector of y-coordinates.
        - `ux` : Matrix representing the x-component of the velocity field.
        - `uy` : Matrix representing the y-component of the velocity field.
    - Outputs:
        - `LC` : Vector of the minimum count of land cells around each coordinate.

3. **myEventXX.m**
    ```matlab
    [value, isterminal, direction] = myEventXX(~, y0);
    ```
    - Inputs:
        - `~`   : Placeholder for time variable, not used in this function.
        - `y0`  : State vector at the current time step.
    - Outputs:
        - `value`      : Condition value for the event function.
        - `isterminal` : Boolean indicating whether the integration should stop.
        - `direction`  : Direction of zero-crossing that the event function detects.

4. **HPPTM.m**
    ```matlab
    [x, y, ts] = HPPTM(Grid_X, Grid_Y, U, V, Time, Param);
    ```
    - Inputs:
        - `Grid_X` : X-coordinates of the grid.
        - `Grid_Y` : Y-coordinates of the grid.
        - `U`      : X-component of the velocity field.
        - `V`      : Y-component of the velocity field.
        - `Time`   : Time vector.
        - `Param`  : Structure containing tracking parameters.
    - Outputs:
        - `x`       : X-coordinates of the particle trajectories.
        - `y`       : Y-coordinates of the particle trajectories.
        - `ts`      : Time vector corresponding to the trajectories.

5. **MainScript.m**
    - The script should be run directly in MATLAB. It reads data from netCDF files, sets tracking parameters, and performs particle tracking using the `HPPTM` function.
    - Make sure to update the paths to the netCDF files and the particle position file as needed.

6. **AnimationScript.m**
    - The script should be run directly in MATLAB. It reads drifter data, plots the bathymetry, and creates animations of particle movements.
    - Set the `Animation` and `VideoOUT` flags to control the animation and video output.

## License

This repository is licensed under the MIT License. See the LICENSE file for more details.

## Author

Mohammad Madani - madanim@uwindsor.ca

## Created Date

2024-06-17

## Acknowledgments

This work is part of a PhD project at the University of Windsor. Special thanks to Dr. Luis F. Leon and Dr. Reza Valipour from Canada Centre for Inland Waters (CCIW) for their support.
