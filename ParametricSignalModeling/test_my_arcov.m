
n= 0:101;
s = 20*cos(0.2*pi*n-0.1*pi) + 22* cos(0.22*pi*n+0.9*pi);
[ans_a, ans_variance] = arcov(s,4);
estimated_a = my_arcov(s,4);

error_a = sum(abs(estimated_a-ans_a))
