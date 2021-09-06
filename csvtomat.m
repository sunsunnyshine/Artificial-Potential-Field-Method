%函数说明：以cell格式读入文件，并取出任意列
file_id = fopen('1.csv');
%第二个参数：csv文件中的列格式；第三个参数：说明当前读入的文件是csv格式；第五个参数：忽略第一行（即不读入表头）
C = textscan(file_id, '%d%f%f%f%f%f%f%f%f%f%f', 'Delimiter', ',', 'HeaderLines', 1 );
%记得关闭文件
fclose(file_id);
%读取保存任意想要测试的列
a=C{2};

