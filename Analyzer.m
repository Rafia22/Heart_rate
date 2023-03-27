clc
close all

fileName = 'Sample_1.mat';
Sec = 10;
data = Orig_Sig;
load(fileName);
Loaded = load(fileName);
fname = fieldnames(Loaded);
x = eval(fname{1});
% x = repmat(x(451:550),10,1);
t = linspace(0,Sec,3600);

%filtering the signal
[b,a] = butter(6,(0.3/180),'high');
filted = filtfilt(b,a,data);
[bb,aa] = butter(6,(25/180),'low');
fdata = filtfilt(bb,aa,filted); %filtered data
%fvtool(bb,aa) to visuaalise filter response

%plotting the filtered signal
plot(t,fdata,'b-')
hold on;

%locating and plotting R peaks
m = mean(fdata); %mean
s = std(fdata); %standard deviation
thrVal = m+s+60; %sets up threshold value
[Rpks,Rpklocs] = findpeaks(fdata,'MinPeakHeight',thrVal,'MinPeakDistance',100);

n = numel(findpeaks(fdata,'MinPeakHeight',thrVal,'MinPeakDistance',100)); %number of R peaks

%to plot all Rpeaks
for k = 1: n;
    plot(t(Rpklocs(k)),Rpks(k),'v','Markersize',10,'color','r')
    locR(k) = t(Rpklocs(k));
end
hold on

%locating and plotting Q points
for k = 1: n;
    current = Rpklocs(k);
    next = current -1;
    while fdata(current) >= fdata(next)
        current = next;
        next = next -1;
    end
    Qpoints(k) = current;
    Qlocs(k) = t(current);
    plot(t(current),fdata(current),'s','MarkerSize',10,'color','r');
end
hold on;

%locating and plotting S points
for k = 1: n;
    current = Rpklocs(k);
    next = current +1;
    while fdata(current) >= fdata(next)
        current = next;
        next = next +1;
    end
    Spoints(k) = current;
    Slocs(k) = t(current);
    plot(t(current),fdata(current),'x','MarkerSize',10,'color','k');
end
hold on;  

for k = 1:n
    QRSduration(k) = Slocs(k)-Qlocs(k);
end

QRS = mean(QRSduration);
fprintf('QRS duration: %.3f\n', QRS);

if QRS>0.1
    fprintf('QRS duration out of range!\n')
    fprintf('Normal range = <0.1\n')
end

%locating and plotting P points
nq = numel(Qpoints);
 
[Qpks,Qpklocs] = findpeaks(fdata,'MinPeakProminence',1,'MinPeakDistance',100);

for k= 1: nq
    current = Qpks(k);
    next = current-1;
    D=find(current<0);
    current(D)=[];
    while fdata(round(current)) >= fdata(round(next))
        current = next;
        next = next -1;
    end
    Ppkpoints(k) = current;
    Plocs(k) = t(round(current));
    plot(t(round(current)),fdata(round(current)),'o','MarkerSize',10,'color','g'); 
end
hold on;

%locating and plotting T points
ns = numel(Spoints)

[Spks,Spklocs] = findpeaks(fdata,'MinPeakProminence',1,'MinPeakDistance',100);

for k=1: ns
    current = Tpks(k);
    next = current+1;
    while fdata(current) >= fdata(next)
        current = next;
        next = next +1;
    end
    Tpkpoints(k) = current;
    Tlocs(k) = t(current);
    plot(t(current),fdata(current),'d','MarkerSize',10,'color','m'); 
end
hold on;

for k = 1:index
    PRinterval(k) = Plocs(k)-Rlocs(k)
end

for k = 1:index
    QTinterval(k) = Tlocs(k)-Qlocs(k);
end

PR = mean(PRinterval);
QT = mean(QTinterval);

fprintf('P-R interval: %.3f\n', PR);
fprintf('Q-T interval: %.3f\n', QT);

if PR<0.12 || PR>0.20
    fprintf('P-R interval out of range!\n')
    fprintf('Normal range = 0.12-0.20\n')
end

if QT>0.38
    fprintf('Q-T interval out of range!\n')
    fprintf('Normal range = <0.38\n')
end