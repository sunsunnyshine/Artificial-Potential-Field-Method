%数据读入
file_id = fopen('3.csv');
%第二个参数：csv文件中的列格式；第三个参数：说明当前读入的文件是csv格式；第五个参数：忽略第一行（即不读入表头）
C = textscan(file_id, '%d%f%f%f%f%f%f%f%f%f%f', 'Delimiter', ',', 'HeaderLines', 1 );
fclose(file_id);
%读取保存任意想要测试的列:此处使用z轴方向
curZ=C{4};
t=C{1};
threshold=0.229;
lineup=curZ+threshold;
linedown=curZ-threshold;
%第一阶段：平滑滤波
cur1=zeros(length(curZ),1);
cur2=zeros(length(curZ),1);
cur3=zeros(length(curZ),1);
cur4=zeros(length(curZ),1);
cur=zeros(length(curZ),1);
%第一次滤波,窗口大小为20
for i=1:20
    cur1(i)=curZ(i);
end
for i=20:length(curZ)
    cur1(i)= (curZ(i)+curZ(i-1)+curZ(i-2)+curZ(i-3)+curZ(i-4)+curZ(i-5)+curZ(i-6)+curZ(i-7)+curZ(i-8)+curZ(i-9)+curZ(i-10)+curZ(i-11)+curZ(i-12)+curZ(i-13)+curZ(i-14)+curZ(i-15)+curZ(i-16)+curZ(i-17)+curZ(i-18)+curZ(i-19))/20;
end
%第二次滤波,窗口大小为10
for i=1:10
    cur2(i)=cur1(i);
end
for i=10:length(curZ)
    cur2(i)= (cur1(i)+cur1(i-1)+cur1(i-2)+cur1(i-3)+cur1(i-4)+cur1(i-5)+cur1(i-6)+cur1(i-7)+cur1(i-8)+cur1(i-9))/10;
end
%第三次滤波,窗口大小为10
for i=1:10
    cur3(i)=cur2(i);
end
for i=10:length(curZ)
    cur3(i)= (cur2(i)+cur2(i-1)+cur2(i-2)+cur2(i-3)+cur2(i-4)+cur2(i-5)+cur2(i-6)+cur2(i-7)+cur2(i-8)+cur2(i-9))/10;
end
%第四次滤波,窗口大小为20
for i=1:20
    cur4(i)=cur3(i);
end
for i=20:length(curZ)
    cur4(i)= (cur3(i)+cur3(i-1)+cur3(i-2)+cur3(i-3)+cur3(i-4)+cur3(i-5)+cur3(i-6)+cur3(i-7)+cur3(i-8)+cur3(i-9)+cur3(i-10)+cur3(i-11)+cur3(i-12)+cur3(i-13)+cur3(i-14)+cur3(i-15)+cur3(i-16)+cur3(i-17)+cur3(i-18)+cur3(i-19))/20;
end
%第五次滤波,窗口大小为20
for i=1:20
    cur(i)=cur4(i);
end
for i=20:length(curZ)
    cur(i)= (cur4(i)+cur4(i-1)+cur4(i-2)+cur4(i-3)+cur4(i-4)+cur4(i-5)+cur4(i-6)+cur4(i-7)+cur4(i-8)+cur4(i-9)+cur4(i-10)+cur4(i-11)+cur4(i-12)+cur4(i-13)+cur4(i-14)+cur4(i-15)+cur4(i-16)+cur4(i-17)+cur4(i-18)+cur4(i-19))/20;
end

%第二阶段：人工势场法
input=cur;
middle=curZ;
n=length(curZ);
%平滑后的输出
output=zeros(1,n);
lookback=5;
for i=1:lookback
    output(i)=input(i);
end
%定义引力、斥力参数
 m1=0.1;%斥力参数50000
 n1=2000;%引力参数
 q=m1/n1;
for i=lookback+1:length(input)
    fprintf('%d:',i);
    %rx=input-x;rc=lineup-x;
    %平衡点平衡方程为：m*1/rc^2 = n*rx^2
    %斥引比q=m/n
    %如果当前距离中线过远或者目标曲线上升很快才进行打边约束
    if(abs(output(i-1)-middle(i-1))<threshold*0.9)
        output(i)=input(i);
        fprintf('不需要斥力约束\n');
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
        r=roots(p);  %求根
        for j=1:4
            %找实数根，rx,rc都应该大于0
            if isreal(r(j)) && r(j)<input(i) && r(j)<lineup(i-1)       
                output(i)=r(j);
                break;
            end       
        end
        fprintf('%f\n',output(i));
    else
         %rx=x-input;rc=x-linedown;
         %平衡点平衡方程为：m*1/rc^2 = n*rx^2 
         c3=-2*linedown(i-lookback)-2*input(i);
         c2=linedown(i-lookback)^2+input(i)^2+4*linedown(i-lookback)*input(i);
         c1=-2*linedown(i-lookback)*input(i)^2+-2*linedown(i-lookback)^2*input(i);
         c0=linedown(i-lookback)^2*input(i)^2-q;
         p=[1 c3 c2 c1 c0];
         r=roots(p);  %求根
         for j=1:4
            %找实数根
            if isreal(r(j)) && r(j)>input(i) && r(j)>linedown(i-1)
                output(i)=r(j);
                break;   
            end
         end
         fprintf('%f\n',output(i));
    end 
end

% %对输出进行平滑滤波
% for i=1:length(output)-3
%     output(i)=(output(i)+output(i+1)+output(i+2))/3;
% end
% for i=1:length(output)-3
%     output(i)=(output(i)+output(i+1)+output(i+2))/3;
% end
% for i=1:length(output)-3
%     output(i)=(output(i)+output(i+1)+output(i+2))/3;
% end

%作图
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