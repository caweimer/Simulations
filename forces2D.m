% Definitions
X = 1;
Y = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Properties of the object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explicit properties
m = 5;          % mass of the object in kg
pos = [0, 5];   % Position vector
v = [1, 2];     % Velocity vector

% Physics Options
g = -9.81;      % Gravity in m/s^2
bounce_dampening = 0.8;

% Simulation Properties
end_time = 5;               % End of simulation in seconds 
dt = 0.01;                  % Time in seconds per iteration
left_bound = -2.5;          % Left wall x pos
right_bound = 2.5;          % Right wall x pos
zero_threshold = 0.1;       % Prevents infinite oscillations

% Global Simulation variables
F = [0, 0];     % Net forces vector
a = [0, 0];     % Acceleration vector

% Initialize objects
figure(1);
p = plot(NaN,NaN,'ro');
xText = text(0,10,"TMP");
yText = text(0,8, "TMP");
xlim([left_bound right_bound])
ylim([-1 20])
line([left_bound,right_bound], [0,0]);
line([left_bound,left_bound], [0,20]);
line([right_bound,right_bound], [0,20]);
axis off;

pause(1);
for n=0:round(end_time/dt)
    F(X) = 0;                           % Sum of forces in x-direction
    F(Y) = m*g;                         % Sum of forces in y-direction
    
    a = (F./m).*dt;                     % Calculated acceleration
    v = v + a;                          % Update current velocity
    
    if pos(Y) + v(Y) < 0
        if abs(bounce_dampening*v(Y)) < zero_threshold
            v(Y) = 0;
        else
            v(Y) = -1*bounce_dampening*v(Y);
        end
    end
    if ((pos(X) + v(X)) < left_bound) || ((pos(X) + v(X)) > right_bound)
        v(X) = -1*bounce_dampening*v(X);
        disp("yee");
    end
    
    pos = pos + v;                      % update position
    
    % Draw scene
    set(p, 'XData', pos(X), 'YData', pos(Y));
    set(xText, 'String', pos(X));
    set(yText, 'String', pos(Y));
    pause(dt)
end