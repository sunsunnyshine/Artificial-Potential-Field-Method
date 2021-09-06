%产生任意形状的信号
%开始时间，结束时间，采样数量n
start_time=0.01;
end_time=40.00;
n=4000;
t=linspace(start_time,end_time,n);
input=10*sin(2*t)-5*cos(20*t+1)+6*sin(4*t+3);
%定义上下界
lineup=8;
linedown=-8;
%平滑后的输出
output=zeros(1,n);
%阻尼的变化程度：该值越大,跟踪原曲线效果越好，但是越可能打边
f=1.2;
%从第一个开始,第一个不需要平滑，根据当前位置计算阻尼比，下一个增量的计算
output(1)=input(1);
%如果快要打边则平滑一下，不打边则完全跟踪原信号
dampling=1-(power(f,abs(output(1)))/power(f,lineup));
delta=input(2)-input(1);
for i=2:length(t)-1
    %输出
    output(i) = output(i-1)+dampling*delta;
    if(abs(output(i))>7.8)
        if(output(i)>0)
            output(i)=7.8;
        else
            output(i)=-7.8;
        end
    end     
    %平滑前的下一个增量
    delta=input(i+1)-input(i);
    %更新阻尼度
    dampling=1-(power(f,abs(output(i)))/power(f,lineup));
end
output(n)= output(n-1)+dampling*delta;
figure(1);
plot(t,input);
hold on;
plot(t,output);
xlabel('时间/s');
line([start_time,end_time],[lineup,lineup],'linestyle','--');
line([start_time,end_time],[linedown,linedown],'linestyle','--');

