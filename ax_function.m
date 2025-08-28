function return_val = petra_ray_ax_unity(params, u, Q)


%look up the action needed:
t_x = params.action_index_xy(u(1));
t_y = params.action_index_xy(u(2));
t_z = params.action_index_z(u(3));
t_r = params.action_index_r(u(4)); %was (-) for direct to Unity - now plus - and will transform to Unity in petra_ax


% Most likely drone state
[~,d_x] = max(Q{1}(:));
[~,d_y] = max(Q{2}(:));
[~,d_z] = max(Q{3}(:));
[~,d_r] = max(Q{4}(:));

% Calculate new intended rotational state in NSEW coords 
current_yaw = params.drone_r_compass(d_r);
past_ori.yaw = current_yaw;
past_ori.pitch = params.camera_pitch(1);
past_ori.roll  = 0;

new_r_state = d_r + t_r;  
if new_r_state <= 0  % Make sure that a +1 rotation from state 8 goes to state 1 etc
    new_r_state = new_r_state+8;
end
if new_r_state > 8
    new_r_state = mod(new_r_state, 8);
end
new_yaw = params.drone_r_compass(new_r_state); % the intended yaw for the next timepoint;



% Clamps
t_x = min(t_x, params.gx - d_x);
t_x = max(t_x, -d_x);
t_y = min(t_y, params.gy - d_y);
t_y = max(t_y, -d_y);
t_z = min(t_z, params.gz - d_z);
t_z = max(t_z, -d_z);

% Rotate translation vector by negative drone angle to local frame
d_angle = params.rotation_angle * (d_r-1);
theta   = - (d_angle - pi/2);   
rotation_mat = [cos(theta), -sin(theta); 
                sin(theta),  cos(theta)];
t_rot   = rotation_mat * [t_x; t_y] ;
t_x_rot = round(10000 * t_rot(1)) / 10000;
t_y_rot = round(10000 * t_rot(2)) / 10000;
t_z     = round(10000 * t_z) / 10000;


% --- convert to NED
actions_out.x     =   t_x_rot*params.grid_scale;   % Displacment in meters in North-South
actions_out.y     =   t_y_rot*params.grid_scale;   % Displacement in meters in East-West
actions_out.z     =   -t_z*params.grid_scale ;     % Displacement in meters in Altitude (positive down)
actions_out.yaw   =   new_yaw;                         % Absolute yaw   in degrees, (NSEW format 0 = north, 90 = east, 190 = south, 270 = west)
actions_out.pitch =   params.camera_pitch(1);          % Absolute pitch in degrees, negative down (0: to hozion), (90: pointing down) pitch of drone == pitch of first camera
actions_out.roll  =   0;                               % Absolute roll  in degrees, default 0

current_ori.yaw   = current_yaw;
current_ori.pitch = params.camera_pitch(1);
current_ori.roll  = 0;

return_val.actions_out = actions_out;
return_val.current_ori = current_ori;

disp('current position')
disp('x')
disp(d_x)
disp('y')
disp(d_y)
disp('z')
disp(d_z)
disp('r')
disp(d_r)

disp('action inputed')
disp('x')
disp(u(1))
disp('y')
disp(u(2))
disp('z')
disp(u(3))
disp('r')
disp(u(4))


disp('past orientation')
disp('yaw')
disp(past_ori.yaw)
disp('pitch')
disp(past_ori.pitch)
disp('roll')
disp(past_ori.roll)

disp('action outputed')
disp('x')
disp(actions_out.x)
disp('y')
disp(actions_out.x)
disp('z')
disp(actions_out.x)
disp('r')

disp('current orientation')
disp('yaw')
disp(current_ori.yaw)
disp('pitch')
disp(current_ori.pitch)
disp('roll')
disp(current_ori.roll)

