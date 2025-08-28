% Matlab:
% action_index_xy [0,-5,5,-25,25]
% action_index_z  [0,-1,1]
% action_index_r  [0,-1,1,-2,2,-5,5]
%
% actions_out.x        % Displacment in meters in North-South
% actions_out.y        % Displacement in meters in East-West
% actions_out.z        % Displacement in meters in Altitude (positive down)
% actions_out.yaw      % Absolute yaw   in degrees, (NSEW format 0 = north, 90 = east, 190 = south, 270 = west)
% actions_out.pitch    % Absolute pitch in degrees, negative down (0: to hozion), (90: pointing down) pitch of drone == pitch of first camera
% actions_out.roll     % Absolute roll  in degrees, default 0

params.action_index_xy = [0,-5,5,-25,25];
params.action_index_z = [0,-1,1];
params.action_index_r = [0,-1,1,-2,2,-5,5];
params.drone_r_compass = [90,45,0,315,270,225,180,135];

params.gx = 450;
params.gy = 600;
params.gz = 75;
params.rotation_angle = 0.785398163397448;
params.grid_scale = 0.200000000000000;
params.camera_pitch = 85;

Q{1} = zeros(450,1);
Q{2} = zeros(600,1);
Q{3} = zeros(75,1);
Q{4} = zeros(8,1);

Q{1}(200,1) = 1;
Q{2}(300,1) = 1;
Q{3}(20,1) = 1;
Q{4}(2,1) = 1;

u = [2 1 1 1 1];

returned = ax_function(params, u, Q);
