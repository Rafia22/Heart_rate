clear
clc
close all

load Sample_1.mat
data = Orig_Sig;
rate = 360;
 
m = mean(data); %mean
s = std(data); %standard deviation
thrVal = m+s+60; %sets up threshold value

plot(data);
title('ECG Data')

[pkv,loc] = findpeaks(data,'MinPeakHeight',thrVal,'MinPeakDistance',100); % finds the peak

n = numel(findpeaks(data,'MinPeakHeight',thrVal,'MinPeakDistance',100));  %calculates the number of peaks

FirstPkLoc = loc(1); 
LastPkLoc = loc(n); 

period = (LastPkLoc-FirstPkLoc)/(n-1);
p_in_sec = period/rate;
f = 1/p_in_sec;
BPM = f * 60