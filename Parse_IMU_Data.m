 fid = fopen('AFO1.txt');
data = textscan(fid, '%f%f%f%f%f%f%f', 'Delimiter', ',');
 fclose(fid);
 fieldarray = horzcat(data{:});
