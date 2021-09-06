[t]=xlsread('2.xlsx',1,'A2:A298');
%读取模拟滤波后的输入
[input]=xlsread('2.xlsx', 1, 'E2:E298');
n=length(input);
%读取上下界
[line_up]=xlsread('2.xlsx', 1, 'F2:F298');
[line_down]=xlsread('2.xlsx', 1, 'G2:G298');
lineup=line_up-0.5;
linedown=line_down+0.5;
% [lineup]=xlsread('2.xlsx', 1, 'K2:K298');
% [linedown]=xlsread('2.xlsx', 1, 'L2:L298');
[middle]=xlsread('2.xlsx', 1, 'D2:D298');
%平滑后的输出
output=zeros(1,n);
output(1)=input(1);
%定义引力、斥力参数
 m1=50000;%斥力参数
 m2=10;
 n1=20;%引力参数
 n2=100;
for i=2:length(input)-2
    fprintf('%d:',i);
    %rx=input-x;rc=lineup-x;
    %平衡点平衡方程为：m*1/rc^2 = n*rx^2
    %斥引比q=m/n
    if(abs(output(i-1)-middle(i-1))>2 && (abs(input(i)-input(i-1))>0.8))
        q=m1/n1;
    else
        q=m2/n2;
    end
    fprintf('%f\t',q);
    fprintf('%f\t',input(i));
    if input(i)>middle(i)
        c3=-2*lineup(i)-2*input(i);
        c2=lineup(i)^2+input(i)^2+4*lineup(i)*input(i);
        c1=-2*lineup(i)*input(i)^2+-2*lineup(i)^2*input(i);
        c0=lineup(i)^2*input(i)^2-q;
        p=[1 c3 c2 c1 c0];
        r=roots(p);  %求根
        for j=1:4
            %找实数根
            if isreal(r(j))
                %rx,rc都应该大于0
                if r(j)<input(i)&&r(j)<lineup(i)
                    output(i)=r(j);
                    break;
                else
                    output(i)=lineup(i); 
                end
            end       
        end
        fprintf('%f\n',output(i));
    else
         %rx=x-input;rc=x-linedown;
         %平衡点平衡方程为：m*1/rc^2 = n*rx^2
         
         c3=-2*linedown(i)-2*input(i);
         c2=linedown(i)^2+input(i)^2+4*linedown(i)*input(i);
         c1=-2*linedown(i)*input(i)^2+-2*linedown(i)^2*input(i);
         c0=linedown(i)^2*input(i)^2-q;
         p=[1 c3 c2 c1 c0];
         r=roots(p);  %求根
         find=0;
         for j=1:4
            %找实数根
            if isreal(r(j))
                %rx,rc都应该大于0
                if r(j)>input(i) && r(j)>linedown(i)
                    output(i)=r(j);
                    find=1;
                    break;
                else
                    output(i)=linedown(i); 
                end
            end
         end 
         fprintf('%f\n',output(i));
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
%红色是上下界
% plot(t,line_up,'color',[136,0,21]/255);
% hold on;
% plot(t,line_down,'color',[136,0,21]/255);
xlabel('时间/s');



    

