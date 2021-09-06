[t]=xlsread('2.xlsx',1,'A2:A298');
%��ȡģ���˲��������
[input]=xlsread('2.xlsx', 1, 'E2:E298');
n=length(input);
%��ȡ���½�
[line_up]=xlsread('2.xlsx', 1, 'F2:F298');
[line_down]=xlsread('2.xlsx', 1, 'G2:G298');
lineup=line_up-0.5;
linedown=line_down+0.5;
% [lineup]=xlsread('2.xlsx', 1, 'K2:K298');
% [linedown]=xlsread('2.xlsx', 1, 'L2:L298');
[middle]=xlsread('2.xlsx', 1, 'D2:D298');
%ƽ��������
output=zeros(1,n);
output(1)=input(1);
output(2)=input(2);
%������������������
 m1=50000;%��������
 m2=0.1;
 n=1;%��������
for i=3:length(input)-2
    fprintf('%d:',i);
    %rx=input-x;rc=lineup-x;
    %ƽ���ƽ�ⷽ��Ϊ��m*1/rc^2 = n*rx^2
    %������q=m/n
    fprintf('%f\t',abs(output(i-1)-middle(i-1)));
    if abs(output(i-1)-middle(i-1))>6 || abs(output(i-2)-middle(i-2))>6 || (abs(output(i-1)-middle(i-1))>2&&((abs(input(i+1)-input(i))>1 && abs(input(i+2)-input(i+1))>1)))
        q=m1/n;
    else 
        q=m2/n;
    end
    fprintf('%f\n',q);
    if input(i)>middle(i)
        c3=-2*lineup(i)-2*input(i);
        c2=lineup(i)^2+input(i)^2+4*lineup(i)*input(i);
        c1=-2*lineup(i)*input(i)^2+-2*lineup(i)^2*input(i);
        c0=lineup(i)^2*input(i)^2-q;
        p=[1 c3 c2 c1 c0];
        r=roots(p);  %���
        for j=1:4
            %��ʵ����
            if isreal(r(j))
                %rx,rc��Ӧ�ô���0
                if r(j)<input(i)&&r(j)<lineup(i)
                    output(i)=r(j);
                    break;
                else
                    output(i)=lineup(i); 
                end
            end
        end
    else
         %rx=x-input;rc=x-linedown;
         %ƽ���ƽ�ⷽ��Ϊ��m*1/rc^2 = n*rx^2
         c3=-2*linedown(i)-2*input(i);
         c2=linedown(i)^2+input(i)^2+4*linedown(i)*input(i);
         c1=-2*linedown(i)*input(i)^2+-2*linedown(i)^2*input(i);
         c0=linedown(i)^2*input(i)^2-q;
         p=[1 c3 c2 c1 c0];
         r=roots(p);  %���
         find=0;
         for j=1:4
            %��ʵ����
            if isreal(r(j))
                %rx,rc��Ӧ�ô���0
                if r(j)>input(i) && r(j)>linedown(i)
                    output(i)=r(j);
                    find=1;
                    break;
                else
                    output(i)=linedown(i); 
                end
            end
         end     
    end 
end
for i=1:length(output)-1
    output(i)=(output(i)+output(i+1))/2;
end
figure(1);
plot(t,input,'color',[4/255 107/255 255/255]) ;
hold on;
plot(t,output,'color',[107/255 4/255 255/255]);
hold on;
plot(t,line_up,'color',[136,0,21]/255);
hold on;
plot(t,line_down,'color',[136,0,21]/255);
%��ɫ�����½�
% plot(t,line_up,'color',[136,0,21]/255);
% hold on;
% plot(t,line_down,'color',[136,0,21]/255);
% hold on;
% plot(t,middle,'color',[136 122 210]/255);
xlabel('ʱ��/s');



    

