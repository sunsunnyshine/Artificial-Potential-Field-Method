%���ݶ���
file_id = fopen('3.csv');
%�ڶ���������csv�ļ��е��и�ʽ��������������˵����ǰ������ļ���csv��ʽ����������������Ե�һ�У����������ͷ��
C = textscan(file_id, '%d%f%f%f%f%f%f%f%f%f%f', 'Delimiter', ',', 'HeaderLines', 1 );
fclose(file_id);
%��ȡ����������Ҫ���Ե���:�˴�ʹ��z�᷽��
curZ=C{4};

T = 0.229;% ���Լ��
a1 = 0.05;% ��ʼrcϵ��
x = curZ;
y2 = zeros(length(x),1);
r1s = zeros(length(x),1);
L1s = [];
last = x(1);
border1 = x-T;
border2 = x+T;
Kr = 0.005;% ����ϵ��
as = zeros(length(x),1);
Fs = zeros(length(x),1);
a2 = 0.02;
forward = 12;
forward_y = zeros(forward,1);
%����˲��������ͱ߽�ľ���
r1_tmp = zeros(forward,1);
r2_tmp = zeros(forward,1);
F1_tmp = zeros(forward,1);
F2_tmp = zeros(forward,1);
F_tmp = zeros(forward,1);
detas = zeros(forward,1);
thre = T/5;
k_break = 0;
last_tmp = x(1);
count = 0;
exp_sum = sum(exp([1:forward]));
for i=1:length(x)-forward
%     if(i==120)
%         disp('a');
%     end
    deta = 0;
    k_break = 0;
    for k=1:forward
        forward_y(k) = a1*x(i+k) + (1-a1)*last_tmp;
        last_tmp = forward_y(k);
        r1_tmp(k) = abs(border1(i+k)-forward_y(k));% �˲�����ͱ߽�ľ���
        r2_tmp(k) = abs(border2(i+k)-forward_y(k));
        if(r1_tmp(k)>2*T || r2_tmp(k)>2*T)
            k_break = k;
            break;
        end
        %deta = deta + 2*(0.9/(1+exp(-1*Kf*F_tmp(k))) - 0.45)*exp(forward-k+1)/exp_sum;
    end
    deta = 2*exp(-1*k_break);% ���λ��ԽԶ��ϵ������ԽС
    if(k_break == 0)
        deta = 0;
    end
    detas(i) = deta;
    a1 = a1 + deta;
    if(a1 > 1)
        a1 = 1;
    end
    disp([num2str(k),' ',num2str(a1),' ',num2str(deta)]);
    yy = a1*x(i) + (1-a1)*last;
    if(abs(border1(i)-yy)>2*T || abs(border2(i)-yy)>2*T)
        disp('out');
    end
    last = yy;
    y2(i) = yy;
    
%     r1 = abs(border1(i)-y2(i));
%     r2 = abs(border2(i)-y2(i));
% 
%     F1 = Kr/(r1*r1);
%     F2 = Kr/(r2*r2);
%     F = abs(F1-F2);

    as(i) = a1;
    if(a1 > 0.02)
        a1 = a1 / 3;
    end
    
    last_tmp = y2(i);
end
figure(1)
subplot(211)
plot(as,'r')
subplot(212)
plot(detas,'b')
figure(2)
% scatter([1:length(x)],x,'b')
% hold on
plot(x,'b');
hold on
plot(border1,'--');
hold on
plot(border2,'--');
hold on
 plot(y2,'r')
 hold on
% plot(oldZ,'y')
y3 = smooth(y2,7);
hold on
plot(y3,'r');
disp('---------------------');
