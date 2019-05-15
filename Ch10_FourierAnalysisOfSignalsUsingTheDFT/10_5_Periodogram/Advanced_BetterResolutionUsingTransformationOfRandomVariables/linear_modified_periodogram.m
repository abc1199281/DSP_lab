function [ax, ay, w, y] = linear_modified_periodogram(x)
    [sx, ax, px] = general_win_periodogram(x,2,512);
    y1 = [x zeros(1,48)] + 0.2*rand(1, 112);
    y2 = [zeros(1,48) x] + 0.2*rand(1,112);
    y = (0.2*y1+(y2)*0.2);
    [sy, ay, py] = general_win_periodogram(y,2,512);
    w = 0:2*pi/512:2*pi-(2*pi/512);
end