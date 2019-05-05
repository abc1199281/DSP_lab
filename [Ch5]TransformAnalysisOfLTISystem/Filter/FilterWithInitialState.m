%% Filter in section. The Usage of Initial State.

% generate signal.
x = randn(10000,1);

% split signal.
x1 = x(1:5000);
x2 = x(5001:end);

% generate filter
b = [2,3];
a = [1,0.2];

% filter seperatly.
[y1,zf] = filter(b,a,x1); %% Please Note: save zero condition.
y2 = filter(b,a,x2,zf);

% filter all
y = filter(b,a,x);

% compare two.
isequal(y,[y1;y2])