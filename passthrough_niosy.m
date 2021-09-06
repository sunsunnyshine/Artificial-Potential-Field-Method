%��������
[t]=xlsread('2.xlsx',1,'A2:A298');
%��ȡģ���˲��������
[input]=xlsread('2.xlsx', 1, 'E2:E298');
n=length(input);
%��ȡƽ�������½�
[line_up]=xlsread('2.xlsx', 1, 'K2:K298');
[line_down]=xlsread('2.xlsx', 1, 'L2:L298');
lineup=line_up-0.5;
linedown=line_down+0.5;
%��ȡԭʼ�����½�
[lineupini]=xlsread('2.xlsx', 1, 'F2:F298');
[linedownini]=xlsread('2.xlsx', 1, 'G2:G298');
[middle]=xlsread('2.xlsx', 1, 'D2:D298');
%ƽ��������
output=zeros(1,n);
lookback=15;
for i=1:lookback
    output(i)=input(i);
end
%������������������
 m1=50000;%��������50000
 n1=20;%��������
 q=m1/n1;
for i=lookback+1:length(input)
    fprintf('%d:',i);
    %rx=input-x;rc=lineup-x;
    %ƽ���ƽ�ⷽ��Ϊ��m*1/rc^2 = n*rx^2
    %������q=m/n
    %�����ǰ�������߹�Զ����Ŀ�����������ܿ�Ž��д��Լ��
    if(abs(output(i-1)-middle(i-1))<2 || (abs(input(i)-input(i-1))<0.8))
        output(i)=input(i);
        fprintf('����Ҫ����Լ��\n');
        continue
    end
    fprintf('%f\t',q);
    fprintf('%f\t',input(i));
    if input(i)>middle(i)
        c3=-2*lineup(i-lookback)-2*input(i);
        c2=lineup(i-lookback)^2+input(i)^2+4*lineup(i-lookback)*input(i);
        c1=-2*lineup(i-lookback)*input(i)^2+-2*lineup(i-lookback)^2*input(i);
        c0=lineup(i-lookback)^2*input(i)^2-q;
        p=[1 c3 c2 c1 c0];
        r=roots(p);  %���
        for j=1:4
            %��ʵ������rx,rc��Ӧ�ô���0
            if isreal(r(j)) && r(j)<input(i) && r(j)<lineup(i-1)       
                output(i)=r(j);
                break;
            end       
        end
        fprintf('%f\n',output(i));
    else
         %rx=x-input;rc=x-linedown;
         %ƽ���ƽ�ⷽ��Ϊ��m*1/rc^2 = n*rx^2 
         c3=-2*linedown(i-lookback)-2*input(i);
         c2=linedown(i-lookback)^2+input(i)^2+4*linedown(i-lookback)*input(i);
         c1=-2*linedown(i-lookback)*input(i)^2+-2*linedown(i-lookback)^2*input(i);
         c0=linedown(i-lookback)^2*input(i)^2-q;
         p=[1 c3 c2 c1 c0];
         r=roots(p);  %���
         for j=1:4
            %��ʵ����
            if isreal(r(j)) && r(j)>input(i) && r(j)>linedown(i-1)
                output(i)=r(j);
                break;   
            end
         end
         fprintf('%f\n',output(i));
    end 
end

%���������ƽ���˲�
for i=1:length(output)-3
    output(i)=(output(i)+output(i+1)+output(i+2))/3;
end
for i=1:length(output)-3
    output(i)=(output(i)+output(i+1)+output(i+2))/3;
end
for i=1:length(output)-3
    output(i)=(output(i)+output(i+1)+output(i+2))/3;
end

%���ӻ�
figure(1);
plot(t,input,'color',[4/255 107/255 255/255]) ;
hold on;
plot(t,output,'color',[107/255 4/255 255/255]);
hold on;
plot(t,lineupini,'color',[136,0,21]/255);
hold on;
plot(t,linedownini,'color',[136,0,21]/255);
%��ɫ�����½�
% plot(t,line_up,'color',[136,0,21]/255);
% hold on;
% plot(t,line_down,'color',[136,0,21]/255);
xlabel('ʱ��/s');



    

