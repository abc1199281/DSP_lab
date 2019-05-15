n = 1:64;
x =  sin(0.3*pi*n) + sin(0.32*pi*n) + 0.5*randn(1,64);
[ax,ay,w,y] = linear_modified_periodogram(x);

subplot(2,1,1);
plot(w,ax,'k');
xlabel('w');
ylabel('PSD');
subplot(2,1,2);
plot(w,ay,'k');
xlabel('w');
ylabel('Modified PSD');