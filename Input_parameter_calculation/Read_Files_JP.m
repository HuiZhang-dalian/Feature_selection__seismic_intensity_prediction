%the program is used to read the Japan's Records
%Infor:the basic information of the ground motion files
function [Infor,Data]=Read_Files_JP(filepath)
Ti_number=17;
% g=9.8;
fid=fopen(filepath);
for i=1:Ti_number
    Tline=fgetl(fid);
    switch i
        case 1
            k=isstrprop(Tline,'digit');
            Infor.Origin_Time=Tline(k);
        case 2
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Lat=str2double(k{1});
        case 3
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Long=str2double(k{1});
        case 4
            k=regexp(Tline,'\d*\.*\d+','match');
            Infor.Depth_km=str2double(k{1});
        case 5
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Magnitude=str2double(k{1});
        case 6
            k=strfind(Tline,' ');
            b=length(k);
            Infor.Station_Code=Tline(k(b)+1:length(Tline));
        case 7
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Station_Lat=str2double(k{1});
        case 8
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Station_Long=str2double(k{1});
        case 9
            k=regexp(Tline,'\-*\d+\.*\d*','match');
            Infor.Station_Height=str2double(k{1});
        case 10
            k=isstrprop(Tline,'digit');
            Infor.Record_Time=Tline(k);
        case 11
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Frequency=str2double(k{1});
        case 12
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Duration_Time=str2double(k{1});
        case 13
            k=isstrprop(Tline,'alpha');
            k(1:4)=0;
            Infor.Direction=Tline(k);
        case 14
            k=regexp(Tline,'\d+','match');
            Infor.Scale_factor=str2double(k{1})/str2double(k{2});
        case 15
            k=regexp(Tline,'\d+\.*\d+','match');
            Infor.Max_Acc_gal=str2double(k{1});
    end
end
Scale=Infor.Scale_factor;
Data=fscanf(fid,'%g')*Scale;
fclose(fid);
end