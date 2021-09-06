%绘图
figure(1);
plot(t,input,'color',[4/255 107/255 255/255]) ;
hold on;
plot(t,output);
hold on;
%红色是上下界
plot(t,lineup,'color',[136,0,21]/255);
hold on;
plot(t,linedown,'color',[136,0,21]/255);
xlabel('时间/s');