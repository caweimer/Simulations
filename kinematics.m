% Initial conditions
ax = 0;
xv0 = 2;
x0 = 2.5;

ay = -9.81;
yv0 = -10;
y0 = 2.5;

dur = 10;               % duration of sim in seconds

dt = 0.05;              % seconds per iteration
n_start = 0;
n_end = round(dur/dt);

% physics properties
dampening = 0.8;

% Initialize plot objects
figure(1);
p = plot(NaN,NaN,'ro');
xText = text(0,10,"TMP");
yText = text(0,8, "TMP");
xlim([-1 6])
ylim([-1 20])
line([-1,6], [0,0]);
line([0,0], [0,10]);
line([5,5], [0,10]);
axis off;

xp = x0;                    % previous X position
xvp = xv0;
yp = y0;                    % previous Y position
yvp = yv0;

pause(1);
yindex = 0;
for n=n_start:n_end
    % update X position
    xf = pos(ax,xv0,xp,dt);
    if xf < 0 || xf > 5
       xv0 = -dampening*(ax*dt + xvp);
       xf = pos(ax,xv0,xp,dt);
    else
        xv0 = (ax*dt + xvp);
    end
    xp = xf;
    xvp = xv0;
    
    % update Y position
    yf = pos(ay,yv0,yp,dt);
    if yf < 0 
        yv0 = -dampening*(ay*dt + yvp);
        yf = pos(ay,yv0,yp,dt);
    else
        yv0 = (ay*dt + yvp);
    end
    yp = yf;
    yvp = yv0;
    
    % Draw scene
    set(p, 'XData', xf, 'YData', yf);
    set(xText, 'String', xf);
    set(yText, 'String', yf);
    pause(dt)
    
    xp = xf;
    yp = yf;
    yindex = yindex + 1;
end

function answer = pos(a,v0,x0,t)
    answer = 0.5*a*t^2 + v0*t + x0;
end