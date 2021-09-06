[t]=xlsread('2.xlsx',1,'A2:A298');
%读取模拟滤波后的输入
[input]=xlsread('2.xlsx', 1, 'E2:E298');
n=length(input);
%读取上下界
[lineup]=xlsread('2.xlsx', 1, 'F2:F298');
[linedown]=xlsread('2.xlsx', 1, 'G2:G298');
[middle]=xlsread('2.xlsx', 1, 'D2:D298');
%平滑后的输出
output=zeros(1,n);
output(1)=input(1);
%定义引力、斥力参数
 m=500;%斥力参数
 n=1;%引力参数
for i=2:length(input)-2
    %rx=input-x;rc=lineup-x;
    %平衡点平衡方程为：m*1/rc^2 = n*rx^2
    %斥引比q=m/n
    if input(i)>middle(i)
        %如果开始呈阶跃靠近边缘的趋势，快速提高斥引比到10000数量级
        if abs(input(i+1)-input(i))>1 && abs(input(i+2)-input(i+1))>1 && input(i)-middle(i)>2
            q=power(100,(input(i)-middle(i))/8);
        %如果不靠近边缘或者靠近边缘但不是阶跃类型的信号，则降低斥引比到1数量级上
        else
            q=power(0.99,8/(input(i)-middle(i)));
        end    
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
    else
        %如果开始呈阶跃靠近边缘的趋势，快速提高斥引比到10000数量级
        if abs(input(i+1)-input(i))>1 && abs(input(i+2)-input(i+1))>1 && middle(i)-input(i)>2
            q=power(100,(middle(i)-input(i))/8);
        %如果不靠近边缘或者靠近边缘但不是阶跃类型的信号，则降低斥引比到1数量级上
        else
            q=power(0.99,8/(middle(i)-input(i)));
        end
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
    end 
end
figure(1);
plot(t,input,'color',[4/255 107/255 255/255]) ;
hold on;
plot(t,output,'color',[107/255 4/255 255/255]);
hold on;
%红色是上下界
plot(t,lineup,'color',[136,0,21]/255);
hold on;
plot(t,linedown,'color',[136,0,21]/255);
xlabel('时间/s');



    