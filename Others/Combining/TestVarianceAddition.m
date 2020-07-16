
%% basic noise (iid)
w1 = randn(10000,1);
w2 = randn(10000,1);

x = w1+w2;

disp('var w1: ');
disp(var(w1));
disp('var w2: ');
disp(var(w2));
disp('corr w1 w2: ');
disp(corr(w1,w2));
disp('var x: ');
disp(var(x));

%% Non iid  noise summation, 
r = 0.75;
mu = 0;
sigma = 2;

% correlated noise generator
M = mu + sigma*randn(10000,2);
R = [1 r ; r  1];
L = chol(R)
M = M*L;
w1 = M(:,1);
w2 = M(:,2);

% random variable addition
x = w1+w2;

disp('var w1: ');
disp(var(w1));
disp('var w2: ');
disp(var(w2));
disp('corr w1 w2: ');
disp(corr(w1,w2)); % confirm the r.
disp('var x: ');
disp(var(x));
disp('var w1 +var w2 + 2*corr(w1,w2)')
C = cov(w1,w2);
disp(var(w1)+var(w2)+2*C(1,2));