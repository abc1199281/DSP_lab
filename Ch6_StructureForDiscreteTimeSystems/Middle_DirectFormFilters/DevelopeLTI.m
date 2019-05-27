t = linspace(-pi,pi,100);
rng default  %initialize random number generator
x = sin(t) + 0.25*rand(size(t));


% 5 order moving average.
windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

Zi=zeros(1,max(length(a),length(b))-1);
[y1 tmp]= myFilter(b,a,x,Zi);
y = filter(b,a,x,Zi);

error = sum(abs(y1-y));
figure;
plot(t,abs(y1-y));
disp(error);

figure;
plot(t,x)
hold on
plot(t,y)
plot(t,y1);
legend('Input Data','Filtered Data','Self Function')

%% IIR Filter
b = [2, 3];
a = [1, 0.2];

[y1 tmp]= myFilter(b,a,x);
y = filter(b,a,x);

error = sum(abs(y1-y));
figure;
plot(t,abs(y1-y));
disp(error);

figure;
plot(t,x)
hold on
plot(t,y);
plot(t,y1);
legend('Input Data','Filtered Data','Self Function')

%% Filter in section

x = randn(10000,1);

x1 = x(1:5000);
x2 = x(5001:end);

b = [2,3];
a = [1,0.2];

[y1,zf] = myFilter(b,a,x1);
y2 = myFilter(b,a,x2,zf);

y = myFilter(b,a,x);

isequal(y,[y1;y2])


