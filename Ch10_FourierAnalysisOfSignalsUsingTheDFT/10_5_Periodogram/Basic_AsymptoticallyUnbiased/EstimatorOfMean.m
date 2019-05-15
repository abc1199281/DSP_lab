rng('default'); % reproductable.

x = rand(1,10000) - 0.5;

m1 = sum(x(1,1:10000))/10000
m2 = sum(x(1,1:1000))/1000
m3 = sum(x(1,1:100))/100
m4 = sum(x(1,1:10))/10