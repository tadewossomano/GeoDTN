clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Lab 3 #1a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%y=-5:0.1:4.99;
f=zeros(100);
y=-5:.1:4.99;
f2=-5:.1:4.99;
s1=zeros(100);          
x=-5:0.1:4.99;
s1=(rectpuls(x./.2))./.2;   %Do 4 dft values of Delta
subplot(3,1,1);
plot(x,s1);
xlabel('x-axis');
ylabel('amplitude');
e = waitforbuttonpress ;  %%%Check the solution
subplot(3,1,2);
s1f=fft2(s1);
plot(f,s1f);
%%
y=-5:0.1:4.99;
x=-5:0.1:4.99;
s2=zeros(100);
s2f=zeros(100);
s2=rectpuls(cos(2.*x)+sin(2.*y));
surf(s2);
s2f=fft2(s2);
plot(sf2);


