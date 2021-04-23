clear all
close all
%%%%% Em [W] %%%%%
% Pin = linspace(0,10,1000)*1e-3;
% A = 10;
% B = 1;
% C = 1e15;
% GdB = A./(sqrt(B + C*Pin.^7));

%%%% em [mW] %%%

Pin = linspace(0,10,1000);
A = 13;
B = 10;
C = 1e-5;
D = 4;

GdB = A./(sqrt(B + C*Pin.^D))
figure(2);
G = 10.^(GdB/10);

figure(1)
plot(Pin,GdB)
xlabel('Pin [mW]')
ylabel('EDFA Gain [dB]')

plot(Pin,G)
xlabel('Pin [mW]')
ylabel('EDFA Gain [linear]')