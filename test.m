figure(1);
xlim([0 10]);
ylim([0 10]);
a = line([2,4], [2,4]);
pause(1);

for n=0:200
    rotateLine(a,n*0.05);
    translateLine(a, [3, n*0.05]);
    pause(0.05);
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

function translateLine(l,pos)
    x = get(l, 'XData');
    y = get(l, 'YData');
    mid = [sum(x)/2, sum(y)/2];
    dpos = pos - mid;
    
    set(l, 'XData', x + dpos(1));
    set(l, 'YData', y + dpos(2));
end