function [ornekler,etiketler] = arffoku(dosyaismi)
fid = fopen(dosyaismi);
c = lower(strtrim(fgetl(fid)));
count =0;
while(isempty(strfind(c,'@data')))
        if (~isempty(strfind(c,'@attribute')))
            count=count +1;
        end
        c = lower(strtrim(fgetl(fid)));
end
a= (ones(count-1,1)*'%f ')';  formatString = [char(a(:)') ' %f'];   
in_data = textscan(fid,formatString,'delimiter', ',', 'commentStyle', '@');
M = [];
ozsayi=size(in_data,2);
for j=1:ozsayi
       M = [M cell2mat(in_data(j))]; 
end
ornekler=M(:,1:ozsayi-1);
etiketler=M(:,ozsayi);

