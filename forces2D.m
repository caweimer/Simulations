% Definitions
X = 1;
Y = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Properties of the object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explicit properties
m = 2;                      % mass of the object in kg
pos = [0, 5];               % Position vector (center of mass)
angle = 0;                  % Angle in radians
omega = 0;                  % Angular velocity
bar_length = 1;             % length of drone 
v = [0, 0];                 % Velocity vector
I = ((1/12)*m*bar_length^2);% Moment 
thrust = [10, 10];          % Thrust vector (left, right)

% Physics Options
g = -9.81;                  % Gravity in m/s^2
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
p = line([0 bar_length], [0 0]);
translateLine(p, pos);
rotateLine(p, angle);
xText = text(-2,4,"TMP");
yText = text(-2,3.5, "TMP");
xlim([left_bound right_bound])
ylim([0 right_bound-left_bound])
line([left_bound,right_bound], [0,0]);
line([left_bound,left_bound], [0,20]);
line([right_bound,right_bound], [0,20]);
%axis off;

pause(1);
for n=0:round(end_time/dt)
    %thrust(Y) = thrust_control(n*dt, pos);
      alpha =  (bar_length*diff(thrust))/(2*I);
      omega = omega + alpha*dt;
      angle = angle + omega*dt;
    
    F(X) = -1*min(thrust)*sin(angle);         % Sum of forces in x-direction
    F(Y) = m*g + -1*min(thrust)*cos(angle);   % Sum of forces in y-direction
    
    a = (F./m).*dt;                         % Calculated acceleration
    v = v + a;                              % Update current velocity
    
    % Boundary checking
    if pos(Y) + v(Y)*dt < 0
        if abs(bounce_dampening*v(Y)) < zero_threshold
            v(Y) = 0;
        else
            v(Y) = -1*bounce_dampening*v(Y);
        end
    end
    
    if ((pos(X) + v(X)*dt) < left_bound) || ((pos(X) + v(X)*dt) > right_bound)
        v(X) = -1*bounce_dampening*v(X);
    end
    
    pos = pos + v*dt;                      % update position
    
    % Draw scene
    rotateLine(p, angle);
    translateLine(p,pos);
    set(xText, 'String', pos(X));
    set(yText, 'String', pos(Y));
    pause(dt)
end

function answer = thrust_control(t, pos)
    cost = 5 - pos(2);
    answer = 50*t * cost;
end

function translateLine(l,pos)
    x = get(l, 'XData');
    y = get(l, 'YData');
    mid = [sum(x)/2, sum(y)/2];
    dpos = pos - mid;
    
    set(l, 'XData', x + dpos(1));
    set(l, 'YData', y + dpos(2));
end

function rotateLine(l, theta)
    x = get(l, 'XData');
    y = get(l, 'YData');
    mag = sqrt((x(2) - x(1))^2 + (y(2) - y(1))^2);
    mid = [sum(x)/2, sum(y)/2];
    xf = [mid(1) + (mag/2)*cos(theta), mid(1) - (mag/2)*cos(theta)];
    yf = [mid(1) + (mag/2)*sin(theta), mid(1) - (mag/2)*sin(theta)];
    set(l, 'XData', xf, 'YData', yf);
end