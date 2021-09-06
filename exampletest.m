%���ݶ���
file_id = fopen('3.csv');
%�ڶ���������csv�ļ��е��и�ʽ��������������˵����ǰ������ļ���csv��ʽ����������������Ե�һ�У����������ͷ��
C = textscan(file_id, '%d%f%f%f%f%f%f%f%f%f%f', 'Delimiter', ',', 'HeaderLines', 1 );
fclose(file_id);
%��ȡ����������Ҫ���Ե���:�˴�ʹ��z�᷽��
curZ=C{4};
t=C{1};
threshold=0.229;
lineup=curZ+threshold;
linedown=curZ-threshold;
%��һ�׶Σ�ƽ���˲�
cur1=zeros(length(curZ),1);
cur2=zeros(length(curZ),1);
cur3=zeros(length(curZ),1);
cur4=zeros(length(curZ),1);
cur=zeros(length(curZ),1);
%��һ���˲�,���ڴ�СΪ20
for i=1:20
    cur1(i)=curZ(i);
end
for i=20:length(curZ)
    cur1(i)= (curZ(i)+curZ(i-1)+curZ(i-2)+curZ(i-3)+curZ(i-4)+curZ(i-5)+curZ(i-6)+curZ(i-7)+curZ(i-8)+curZ(i-9)+curZ(i-10)+curZ(i-11)+curZ(i-12)+curZ(i-13)+curZ(i-14)+curZ(i-15)+curZ(i-16)+curZ(i-17)+curZ(i-18)+curZ(i-19))/20;
end
%�ڶ����˲�,���ڴ�СΪ10
for i=1:10
    cur2(i)=cur1(i);
end
for i=10:length(curZ)
    cur2(i)= (cur1(i)+cur1(i-1)+cur1(i-2)+cur1(i-3)+cur1(i-4)+cur1(i-5)+cur1(i-6)+cur1(i-7)+cur1(i-8)+cur1(i-9))/10;
end
%�������˲�,���ڴ�СΪ10
for i=1:10
    cur3(i)=cur2(i);
end
for i=10:length(curZ)
    cur3(i)= (cur2(i)+cur2(i-1)+cur2(i-2)+cur2(i-3)+cur2(i-4)+cur2(i-5)+cur2(i-6)+cur2(i-7)+cur2(i-8)+cur2(i-9))/10;
end
%���Ĵ��˲�,���ڴ�СΪ20
for i=1:20
    cur4(i)=cur3(i);
end
for i=20:length(curZ)
    cur4(i)= (cur3(i)+cur3(i-1)+cur3(i-2)+cur3(i-3)+cur3(i-4)+cur3(i-5)+cur3(i-6)+cur3(i-7)+cur3(i-8)+cur3(i-9)+cur3(i-10)+cur3(i-11)+cur3(i-12)+cur3(i-13)+cur3(i-14)+cur3(i-15)+cur3(i-16)+cur3(i-17)+cur3(i-18)+cur3(i-19))/20;
end
%������˲�,���ڴ�СΪ20
for i=1:20
    cur(i)=cur4(i);
end
for i=20:length(curZ)
    cur(i)= (cur4(i)+cur4(i-1)+cur4(i-2)+cur4(i-3)+cur4(i-4)+cur4(i-5)+cur4(i-6)+cur4(i-7)+cur4(i-8)+cur4(i-9)+cur4(i-10)+cur4(i-11)+cur4(i-12)+cur4(i-13)+cur4(i-14)+cur4(i-15)+cur4(i-16)+cur4(i-17)+cur4(i-18)+cur4(i-19))/20;
end

%�ڶ��׶Σ��˹��Ƴ���
input=cur;
middle=curZ;
n=length(curZ);
%ƽ��������
output=zeros(1,n);
lookback=5;
for i=1:lookback
    output(i)=input(i);
end
%������������������
 m1=0.1;%��������50000
 n1=2000;%��������
 q=m1/n1;
for i=lookback+1:length(input)
    fprintf('%d:',i);
    %rx=input-x;rc=lineup-x;
    %ƽ���ƽ�ⷽ��Ϊ��m*1/rc^2 = n*rx^2
    %������q=m/n
    %�����ǰ�������߹�Զ����Ŀ�����������ܿ�Ž��д��Լ��
    if(abs(output(i-1)-middle(i-1))<threshold*0.9)
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

% %���������ƽ���˲�
% for i=1:length(output)-3
%     output(i)=(output(i)+output(i+1)+output(i+2))/3;
% end
% for i=1:length(output)-3
%     output(i)=(output(i)+output(i+1)+output(i+2))/3;
% end
% for i=1:length(output)-3
%     output(i)=(output(i)+output(i+1)+output(i+2))/3;
% end

%��ͼ
figure(1);
plot(t,curZ,'color',[4/255 107/255 255/255]) ;
hold on;
plot(t,cur,'color',[4/255 107/255 255/255],'linewidth',1) ;
hold on;
% plot(t,cur1,'color',[4/255 137/255 255/255],'linewidth',1) ;
plot(t,lineup,'color',[136,0,21]/255);
hold on;
plot(t,linedown,'color',[136,0,21]/255);
hold on;
plot(t,output,'color',[136,255,21]/255);