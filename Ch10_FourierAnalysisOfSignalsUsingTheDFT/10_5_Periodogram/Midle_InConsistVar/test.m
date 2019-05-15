
N1 = 512;
N2 = 1024;

rng('default');
x = randn(1,N1);

[s1, as1, phs1] = windowed_periodogram(x,rectwin(length(x)),N1);
[s2, as2, phs2] = windowed_periodogram(x,rectwin(length(x)),N2);

figure;
subplot(2,1,1);
plot(as1(length(as1)/2:end));
var1 = var(as1(length(as1)/2:end));
xlabel('bins');
ylabel('PDS');
title(['N = 1024,var = ' num2str(var1)]);
subplot(2,1,2);
plot(as2(length(as2)/2:end));
var2 = var(as2(length(as2)/2:end));
xlabel('bins');
ylabel('PDS');
title(['N = 2048, var = ' num2str(var2)]);