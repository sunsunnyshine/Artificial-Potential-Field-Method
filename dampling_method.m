%����������״���ź�
%��ʼʱ�䣬����ʱ�䣬��������n
start_time=0.01;
end_time=40.00;
n=4000;
t=linspace(start_time,end_time,n);
input=10*sin(2*t)-5*cos(20*t+1)+6*sin(4*t+3);
%�������½�
lineup=8;
linedown=-8;
%ƽ��������
output=zeros(1,n);
%����ı仯�̶ȣ���ֵԽ��,����ԭ����Ч��Խ�ã�����Խ���ܴ��
f=1.2;
%�ӵ�һ����ʼ,��һ������Ҫƽ�������ݵ�ǰλ�ü�������ȣ���һ�������ļ���
output(1)=input(1);
%�����Ҫ�����ƽ��һ�£����������ȫ����ԭ�ź�
dampling=1-(power(f,abs(output(1)))/power(f,lineup));
delta=input(2)-input(1);
for i=2:length(t)-1
    %���
    output(i) = output(i-1)+dampling*delta;
    if(abs(output(i))>7.8)
        if(output(i)>0)
            output(i)=7.8;
        else
            output(i)=-7.8;
        end
    end     
    %ƽ��ǰ����һ������
    delta=input(i+1)-input(i);
    %���������
    dampling=1-(power(f,abs(output(i)))/power(f,lineup));
end
output(n)= output(n-1)+dampling*delta;
figure(1);
plot(t,input);
hold on;
plot(t,output);
xlabel('ʱ��/s');
line([start_time,end_time],[lineup,lineup],'linestyle','--');
line([start_time,end_time],[linedown,linedown],'linestyle','--');

