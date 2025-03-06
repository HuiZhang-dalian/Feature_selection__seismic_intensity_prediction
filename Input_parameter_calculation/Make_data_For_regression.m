clear,close all;
%%数据处理
fid_NS='E:\实时更新LSTM\zh(1)\25gal-\' %有数据的文件夹
fid_EW='E:\实时更新LSTM\zh(1)\25gal-\'
fid_UD='E:\实时更新LSTM\zh(1)\25gal-\'
filename_NS=dir([fid_NS,'*.NS']);
filename_EW=dir([fid_EW,'*.EW']);
filename_UD=dir([fid_UD,'*.UD']);
% filename1=dir([source_path, '*.UD']);
% filename2=dir([source_path, '*.EW']);
% filename3=dir([source_path, '*.NS']);

n=length(filename_NS);
FileName=cell(n,1);
for k1=1:n
    ss=length(filename_NS(k1).name);
    FileName{k1}=filename_NS(k1).name(1:ss-3);
end

for i= 1:length(filename_NS)
    [Infor,Data_NS]=Read_Files_JP([fid_NS,'\',filename_NS(i).name]);
    [Infor,Data_EW]=Read_Files_JP([fid_EW,'\',filename_EW(i).name]);
    [Infor,Data_UD]=Read_Files_JP([fid_UD,'\',filename_UD(i).name]);
    %p-wave picked
    dt = 1/Infor.Frequency;
    [SL]=STALTA(Data_UD,dt);
    t=dt:dt:dt*length(Data_UD);
    a=5./dt; % 纭畾鍦伴渿鍔ㄧ殑鐐? 鍒犻櫎5绉?
    aa=find(SL(a+1:end)>10); %501:end
    
    % Velovity
    velocity_UD = acc2vel(Data_UD, dt); % cm/s
    velocity_EW = acc2vel(Data_EW, dt); % cm/s
    velocity_NS = acc2vel(Data_NS, dt); % cm/s
    
    % diplace
    dis_UD = acc2dis(Data_UD, dt);
    dis_EW = acc2dis(Data_EW, dt);
    dis_NS = acc2dis(Data_NS, dt);
    %average
    acceleration_total = (Data_UD.^2 + Data_EW.^2 + Data_NS.^2).^0.5; % total_acceleration
    velocity_total = (velocity_UD.^2 + velocity_EW.^2 + velocity_NS.^2).^0.5; % total_elocity
    dis_total = (dis_UD.^2 + dis_EW.^2 + dis_NS.^2).^0.5; % total_dis
    %Pa_Pv_Pd_max_direction
    if max(abs(Data_NS))>max(abs(Data_EW))
        acceleration_max=Data_NS;%relatively large
    else
        acceleration_max=Data_EW;%relatively large
    end
    
    % export data for regression
    N=2200
    record_UD(1:length(Data_UD(a+aa(1):a+aa(1)+N-1)),i)=Data_UD(a+aa(1):a+aa(1)+N-1);
    record_NS(1:length(Data_NS(a+aa(1):a+aa(1)+N-1)),i)=Data_NS(a+aa(1):a+aa(1)+N-1);
    record_EW(1:length(Data_EW(a+aa(1):a+aa(1)+N-1)),i)=Data_EW(a+aa(1):a+aa(1)+N-1);
    record_max(1:length(acceleration_max(a+aa(1):a+aa(1)+N-1)),i)=acceleration_max(a+aa(1):a+aa(1)+N-1);
    
    len_time_step = length(Data_EW(a+aa(1):a+aa(1)+N-1));
    for k=1:len_time_step
        % realtime_accceleration
        realtime_UD = Data_UD((a+aa(1)):(a+aa(1)+k));
        realtime_EW = Data_EW((a+aa(1)):(a+aa(1)+k));
        realtime_NS = Data_NS((a+aa(1)):(a+aa(1)+k));
        realtime_max= acceleration_max((a+aa(1)):(a+aa(1)+k));
        % realtime_velocity
        real_velocity_UD = acc2vel(realtime_UD(1:k+1), dt); % cm/s
        real_velocity_EW = acc2vel(realtime_EW(1:k+1), dt); % cm/s
        real_velocity_NS = acc2vel(realtime_NS(1:k+1), dt); % cm/s
        real_velocity_max = acc2vel(realtime_max(1:k+1), dt); % cm/s
        % realtime_dis
        real_dis_UD = acc2dis(realtime_UD(1:k+1), dt);
        real_dis_EW = acc2dis(realtime_EW(1:k+1), dt);
        real_dis_NS = acc2dis(realtime_NS(1:k+1), dt);
        real_dis_max = acc2dis(realtime_max(1:k+1), dt);
        % real_Pd_Pv_Pa, three direction; largest direction; vertical direction;
        %vertical direction Pa_UD; Pv_UD; Pd_UD;
        real_acceleration_UD=(realtime_UD);
        real_velocity_UD=(real_velocity_UD);
        real_dis_UD=(real_dis_UD);
        %max value direction Pa_max; Pv_max; Pd_max;
        real_acceleration_Pa_max=(realtime_max);
        real_velocity_Pv_max=(real_velocity_max);
        real_dis_Pd_max=(real_dis_max);
        %three direction Pa_three; Pv_three; Pd_three;
        real_acceleration_Pa_three =(realtime_EW.^2 + realtime_NS.^2+realtime_UD.^2).^0.5;
        real_velocity_total_Pv_three=(real_velocity_UD.^2 + real_velocity_EW.^2+real_velocity_NS.^2).^0.5;
        real_velocity_total_Pd_three=(real_dis_UD.^2 + real_dis_EW.^2+real_dis_NS.^2).^0.5;
        % real_Pd_Pv_Pa, three direction; largest direction; vertical direction;
 %% Pa 
        % Pa_max
        temp_Pa_max = max(abs(realtime_max));
        real_Pa_max(k,i)=temp_Pa_max;
        % Pa
        temp_Pa = max(abs(realtime_UD));
        real_Pa(k,i)=temp_Pa;
        % Pa_3
        temp_Pa_3 = max(abs(real_acceleration_Pa_three));
        real_Pa_3(k,i)=temp_Pa_3;
 %% Pv      
        % Pv_max
        temp_Pv_max = max(abs(real_velocity_max));
        real_Pv_max(k,i)=temp_Pv_max;
        % Pv
        temp_Pv = max(abs(real_velocity_UD));
        real_Pv(k,i)=temp_Pv;
        % Pv_3
        temp_Pv_3 = max(abs(real_velocity_total_Pv_three));
        real_Pv_3(k,i)=temp_Pv_3;        
%% Pd        
        % Pd_max
        temp_Pd_max = max(abs(real_dis_max));
        real_Pd_max(k,i)=temp_Pd_max;
        % Pd
        temp_Pd = max(abs(real_dis_UD));
        real_Pd(k,i)=temp_Pd;
        % Pd_3
        temp_Pd_3 = max(abs(real_velocity_total_Pd_three));
        real_Pd_3(k,i)=temp_Pd_3;
%% CAA
        %  CAA_max
        CAA_max=CAVS(realtime_max,dt);
        real_CAA_max(k,i)=CAA_max;
        %  CAA
        temp_CAA = CAVS(realtime_UD,dt);
        real_CAA(k,i)=temp_CAA;
        % CAA_3
        temp_CAA_3 = CAVS(real_acceleration_Pa_three,dt);
        real_CAA_3(k,i)=temp_CAA_3;        
%% CAV
        %  CAV_max
        CAV_max=CAVS(real_velocity_max,dt);
        real_CAV_max(k,i)= CAV_max;
        %  CAA
        temp_CAV = CAVS(real_velocity_UD,dt);
        real_CAV(k,i)=temp_CAV;
        % CAA_3
        temp_CAV_3 = CAVS(real_velocity_total_Pv_three,dt);
        real_CAV_3(k,i)=temp_CAV_3;          
%% CAD
        %  CAD_max
        CAD_max=CAVS(real_dis_max,dt);
        real_CAD_max(k,i)= CAD_max;
        %  CAD
        temp_CAD = CAVS(real_dis_UD,dt);
        real_CAD(k,i)=temp_CAD;
        % CAA_3
        temp_CAV_3 = CAVS(real_velocity_total_Pd_three,dt);
        real_CAV_3(k,i)=temp_CAV_3; 
%% IV2
        %  IV2_max
        Iv2_max=Iv2(real_velocity_max,dt);
        real_Iv2_max(k,i)=Iv2_max;  
        %  IV2  
        temp_Iv2=Iv2(real_velocity_UD,dt);
        real_Iv2(k,i)=temp_Iv2;        
        %  IV2_3  
        temp_Iv2_3=Iv2(real_velocity_total_Pv_three,dt);
        real_Iv2_3(k,i)=temp_Iv2_3;      
%% ID2
        %  ID2_max
        Id2_max=Iv2(real_dis_max,dt);
        real_Id2_max(k,i)=Id2_max;  
        %  ID2  
        temp_Id2=Iv2(real_dis_UD,dt);
        real_Id2(k,i)=temp_Id2;        
        %  ID2_3  
        temp_Id2_3=Iv2( real_velocity_total_Pd_three,dt);
        real_Id2_3(k,i)=temp_Id2_3;         
%% Arial
        %  Arial_max
        Ia_max=Arias(realtime_max,dt);
        real_Ia_max(k,i)=Ia_max;
        %  Arial
        temp_Arial = Arias(realtime_UD,dt);
        real_Arial(k,i)= temp_Arial;
        % CAA_3
        temp_Arial_3 =  Arias(real_acceleration_Pa_three,dt);
        real_Arial_3(k,i)=temp_Arial_3;
        
            
%% DI
        %Arial_max
        DI_max=DI1(dt,realtime_max);
        real_DI_max(k,i)=DI_max; 
        %Arial
        temp_DI=DI1(dt,realtime_UD);
        real_DI(k,i)= temp_DI; 
        % DI_3
       temp_DI_3=DI_function(dt,realtime_UD,realtime_EW,realtime_NS);
       real_temp_DI_3(k,i)=temp_DI_3;

%% tc
%         %tc_max
%         tc_max=tc1(real_dis_Pd_max,real_velocity_max,dt);
%         real_tc_max(k,i)=tc_max; 
        %tc
        temp_tc=tc1(real_dis_UD,real_velocity_UD,dt);
        real_tc(k,i)= temp_tc;
%         %tc_3
%         temp_tc_3=tc1(real_velocity_total_Pv_three,real_velocity_total_Pd_three,dt);
%         real_temp_tc_3(k,i)= temp_tc_3;        
%% tva        
        temp_tva= temp_Pa./temp_Pv;
        real_tva(k,i)= temp_tva;       
%% Tp        
        temp_tp= temp_tc./temp_Pd;
        real_tp(k,i)= temp_tp;   
%% Amax            
        [f,temp_Amax,XW,XWC]=FFT1(dt,realtime_UD);
        real_Amax(k,i)= max(abs(temp_Amax));     
              
    end
    fprintf('i=%d / n=%d',i, n);
    fprintf('\n')   
end


% xlswrite([fid1,'lenth.xlsx'],lenth');
%% write_data
target_path = 'E:\实时更新LSTM\zh(1)\预警参数\参考祎天给出的修改数据\';
Columns={'FileName'};
C=table(FileName,'VariableNames',Columns);
writetable(C,[target_path, 'name_station.csv']);
 %% Pa 
        % Pa_max
        real_Pa_max = real_Pa_max';
        T = table(FileName,real_Pa_max);
        writetable(T,[target_path, 'real_Pa_max.csv']);

        % Pa
        real_Pa = real_Pa';
        T = table(FileName,real_Pa);
        writetable(T,[target_path, 'real_Pa.csv']);

        % Pa_3
        real_Pa_3 = real_Pa_3';
        T = table(FileName,real_Pa_3);
        writetable(T,[target_path, 'real_Pa_3.csv']);
        
 %% Pv      
        % Pv_max
        real_Pv_max = real_Pv_max';
        T = table(FileName,real_Pv_max);
        writetable(T,[target_path, 'real_Pv_max.csv']);       

        % Pv
        real_Pv = real_Pv';
        T = table(FileName,real_Pv);
        writetable(T,[target_path, 'real_Pv.csv']);          

        % Pv_3
        real_Pv_3 = real_Pv_3';
        T = table(FileName,real_Pv_3);
        writetable(T,[target_path, 'real_Pv_3.csv']);
%% Pd        
        % Pd_max
        real_Pd_max = real_Pd_max';
        T = table(FileName,real_Pd_max);
        writetable(T,[target_path, 'real_Pd_max.csv']);        
        
        % Pd
        real_Pd = real_Pd';
        T = table(FileName,real_Pd);
        writetable(T,[target_path, 'real_Pd.csv']);         

        % Pd_3
        real_Pd_3 = real_Pd_3';
        T = table(FileName,real_Pd_3);
        writetable(T,[target_path, 'real_Pd_3.csv']);          
%% CAA
        %  CAA_max
        real_CAA_max = real_CAA_max';
        T = table(FileName,real_CAA_max);
        writetable(T,[target_path, 'real_CAA_max.csv']);          
        
        %  CAA
        real_CAA = real_CAA';
        T = table(FileName,real_CAA);
        writetable(T,[target_path, 'real_CAA.csv']);  

        % CAA_3
        real_CAA_3 = real_CAA_3';
        T = table(FileName,real_CAA_3);
        writetable(T,[target_path, 'real_CAA_3.csv']);         
%% CAV
        %  CAV_max
        real_CAV_max = real_CAV_max';
        T = table(FileName,real_CAV_max);
        writetable(T,[target_path, 'real_CAV_max.csv']);         
        
        %  CAA
        real_CAV = real_CAV';
        T = table(FileName,real_CAV);
        writetable(T,[target_path, 'real_CAV.csv']);            
        
        
        % CAA_3
        real_CAV_3 = real_CAV_3';
        T = table(FileName,real_CAV_3);
        writetable(T,[target_path, 'real_CAV_3.csv']);          
        
%% CAD
        %  CAD_max
        real_CAD_max = real_CAD_max';
        T = table(FileName,real_CAD_max);
        writetable(T,[target_path, 'real_CAD_max.csv']);          

        %  CAD
        real_CAD = real_CAD';
        T = table(FileName,real_CAD);
        writetable(T,[target_path, 'real_CAD.csv']);          
        
        % CAA_3
        real_CAV_3 = real_CAV_3';
        T = table(FileName,real_CAV_3);
        writetable(T,[target_path, 'real_CAV_3.csv']);         
%% IV2
        %  IV2_max
        real_Iv2_max = real_Iv2_max';
        T = table(FileName,real_Iv2_max);
        writetable(T,[target_path, 'real_Iv2_max.csv']);         
         
        %  IV2
        real_Iv2 = real_Iv2';
        T = table(FileName,real_Iv2);
        writetable(T,[target_path, 'real_Iv2.csv']);          
        
       
        %  IV2_3
        real_Iv2_3 = real_Iv2_3';
        T = table(FileName,real_Iv2_3);
        writetable(T,[target_path, 'real_Iv2_3.csv']);        
        
%% ID2
        %  ID2_max
        real_Id2_max = real_Id2_max';
        T = table(FileName,real_Id2_max);
        writetable(T,[target_path, 'real_Id2_max.csv']);          
        
        %  ID2
        real_Id2 = real_Id2';
        T = table(FileName,real_Id2);
        writetable(T,[target_path, 'real_Id2.csv']);         
        
      
        %  ID2_3
        real_Id2_3 = real_Id2_3';
        T = table(FileName,real_Id2_3);
        writetable(T,[target_path, 'real_Id2_3.csv']);        
%% Arial
        %  Arial_max
        real_Ia_max = real_Ia_max';
        T = table(FileName,real_Ia_max);
        writetable(T,[target_path, 'real_Ia_max.csv']);         
        
        %  Arial
        real_Arial = real_Arial';
        T = table(FileName,real_Arial);
        writetable(T,[target_path, 'real_Arial.csv']);             

        % CAA_3
        real_Arial_3 = real_Arial_3';
        T = table(FileName,real_Arial_3);
        writetable(T,[target_path, 'real_Arial_3.csv']);          
%% DI
        %Arial_max
        real_DI_max =exp(real_DI_max');
        T = table(FileName,real_DI_max);
        writetable(T,[target_path, 'real_DI_max.csv']);          
        
        %Arial
        real_DI = exp(real_DI');
        T = table(FileName,real_DI);
        writetable(T,[target_path, 'real_DI.csv']);          
        

        % DI_3
        real_temp_DI_3 =exp(real_temp_DI_3');
        T = table(FileName,real_temp_DI_3);
        writetable(T,[target_path, 'real_temp_DI_3.csv']);         
        
%% tc
        %tc
        real_tc = real_tc';
        T = table(FileName,real_tc);
        writetable(T,[target_path, 'real_tc.csv']);          
%% tva
        real_tva = real_tva';
        T = table(FileName,real_tva);
        writetable(T,[target_path, 'real_tva.csv']);   

%% Tp        
        real_tp = real_tp';
        T = table(FileName,real_tp);
        writetable(T,[target_path, 'real_tp.csv']);  
%% Amax     
        real_Amax = real_Amax';
        T = table(FileName,real_Amax);
        writetable(T,[target_path, 'real_Amax.csv']);  

%% time history
       %UD
       record_UD = record_UD';
       T = table(FileName,record_UD);
       writetable(T,[target_path, 'record_UD.csv']);
       %EW
       record_EW = record_EW';
       T = table(FileName,record_EW);
       writetable(T,[target_path, 'record_EW.csv']);       

       %NS
       record_NS = record_NS';
       T = table(FileName,record_NS);
       writetable(T,[target_path, 'record_NS.csv']);          
       
       % record_max
       record_max = record_max';
       T = table(FileName,record_max);
       writetable(T,[target_path, 'record_max.csv']);            

        
    
 