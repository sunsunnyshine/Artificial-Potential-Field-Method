[t]=xlsread('2.xlsx',1,'A2:A298');
%��ȡģ���˲��������
[input]=xlsread('2.xlsx', 1, 'E2:E298');
n=length(input);
%��ȡ���½�
[lineup]=xlsread('2.xlsx', 1, 'F2:F298');
[linedown]=xlsread('2.xlsx', 1, 'G2:G298');
[middle]=xlsread('2.xlsx', 1, 'D2:D298');
%ƽ��������
output=zeros(1,n);
output(1)=input(1);
%������������������
 m=500;%��������
 n=1;%��������
for i=2:length(input)-2
    %rx=input-x;rc=lineup-x;
    %ƽ���ƽ�ⷽ��Ϊ��m*1/rc^2 = n*rx^2
    %������q=m/n
    if input(i)>middle(i)
        %�����ʼ�ʽ�Ծ������Ե�����ƣ�������߳����ȵ�10000������
        if abs(input(i+1)-input(i))>1 && abs(input(i+2)-input(i+1))>1 && input(i)-middle(i)>2
            q=power(100,(input(i)-middle(i))/8);
        %�����������Ե���߿�����Ե�����ǽ�Ծ���͵��źţ��򽵵ͳ����ȵ�1��������
        else
            q=power(0.99,8/(input(i)-middle(i)));
        end    
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
        %�����ʼ�ʽ�Ծ������Ե�����ƣ�������߳����ȵ�10000������
        if abs(input(i+1)-input(i))>1 && abs(input(i+2)-input(i+1))>1 && middle(i)-input(i)>2
            q=power(100,(middle(i)-input(i))/8);
        %�����������Ե���߿�����Ե�����ǽ�Ծ���͵��źţ��򽵵ͳ����ȵ�1��������
        else
            q=power(0.99,8/(middle(i)-input(i)));
        end
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
figure(1);
plot(t,input,'color',[4/255 107/255 255/255]) ;
hold on;
plot(t,output,'color',[107/255 4/255 255/255]);
hold on;
%��ɫ�����½�
plot(t,lineup,'color',[136,0,21]/255);
hold on;
plot(t,linedown,'color',[136,0,21]/255);
xlabel('ʱ��/s');



    