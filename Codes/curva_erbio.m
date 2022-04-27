clear all
close all
%%%%% Em [W] %%%%%
% Pin = linspace(0,10,1000)*1e-3;
% A = 10;
% B = 1;
% C = 1e15;
% GdB = A./(sqrt(B + C*Pin.^7));

%%%% em [mW] %%%

Pin = linspace(0,30,1000);
A = 32;
B = 8;
C = 0.5e-5;
D = 4;

GdB = A./(sqrt(B + C*Pin.^D))
G = 10.^(GdB/10);

figure(1)
plot(Pin,GdB)
xlabel('Pin [mW]')
ylabel('EDFA Gain [dB]')

% figure(2)
% plot(Pin,G)
% xlabel('Pin [mW]')
% ylabel('EDFA Gain [linear]')