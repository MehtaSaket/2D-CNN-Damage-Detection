clc;
clear;

CDFNAME = 'sample';             %Base name of CDF
FID = 1;                        %ID of CDF

DIR = 'D:\btech\2nd-Year\2ndsem\explo\CNN_Simple\CNN_Simple';

dataFile = 'train_sample';             %File name of the data file
nClasses = 2;                          %Number of classes

frameSize = 512;       %Number of samples in each frame.
%Note: frameSize should be a common divisor for the number of samples in each class

trainTest = 0; %0: train; 1:test

percentageTrain = 0.4; %Percentage of data used for training

normalized = 1;  %1:normalize, 0:do not normalize
shuffled = 1;    %1:shuffle before dividing into training and testing data, 0:do not shuffle

%CNN Training parameters
noITR = 200;                      %Number of iteration
noRUNS = 1;                       %Number of runs
update = 24;
trRATE = 0.5;
lp = 0.001;
decay_lp = 0.99;
stop_ce = 0.01;
delta_mse = 0.001;
fs = 73;                          %Filter size
ssx = 2;                          %Sub-sampling ratio
cnnNol = 3;                       %Number of CNN layers
mlpNol = 3;                       %Number of MLP layers
cnnStruct = '0 8 8 5 5 0';        %CNN structure

%Delete classification results of the previous run
fidd = [DIR '\CNN_APP\CDF_FILES\' CDFNAME '_' num2str(FID) '_CNN.txt'];
if exist(fidd, 'file')==2
  delete(fidd);
end

%Generate training and testing CDFs
[sizes,isSingle] = generateCDF(CDFNAME,FID,[DIR '\DATA_FILES\'],[DIR '\CNN_APP\CDF_FILES\'],dataFile,nClasses,frameSize,percentageTrain,normalized,shuffled,trainTest);

disp(['Number of classes: ' num2str(nClasses) newline]);
for i = 1:nClasses
    disp(['Number of frames under Class ' num2str(i) ' = ' num2str(sizes(i)/frameSize) newline]);
end
disp(['Total number of frames = ' num2str(sum(sizes)/frameSize) newline]);

if trainTest == 0
    disp(['Number of training frames = ' num2str(floor(percentageTrain*sum(sizes)/frameSize)) newline]);
    disp(['Number of testing frames = ' num2str(sum(sizes)/frameSize-floor(percentageTrain*sum(sizes)/frameSize)) newline]);
end

%Create conf file
createConf(trainTest,CDFNAME,FID,[DIR '\CNN_APP\Release\'],[DIR '\CNN_APP\CDF_FILES\'],noITR,noRUNS,update,trRATE,lp,decay_lp,stop_ce,delta_mse,fs,ssx,cnnNol,mlpNol,frameSize,cnnStruct);

%Run CNN training (or testing)
disp('-----------------------------------------------------');
if trainTest == 0
    disp(['Running Training ...' newline]);
    system(['cd ' DIR '\CNN_APP\Release\' ' &CNNTestApp.exe'],'-echo');
    disp('-----------------------------------------------------');
else
    [aa,bb] = system(['cd ' DIR '\CNN_APP\Release\' ' &CNNTestApp.exe']);
end

%Import classifcation results from the TXT file
N_TR = 13;
N_TE = 13+1+nClasses+2+1;
M_TR = importdata(fidd,'\t',N_TR);
M_TR = M_TR.data(2:end,2:end);
M_TE = importdata(fidd,'\t',N_TE);
M_TE = M_TE.data(2:end,2:end);

M_T = M_TR+M_TE;

M_TR_F = [[-1;(1:nClasses)'] [1:nClasses;M_TR]];
M_TE_F = [[-1;(1:nClasses)'] [1:nClasses;M_TE]];
M_T_F = [[-1;(1:nClasses)'] [1:nClasses;M_T]];

if isSingle == 1
    for i = 2:length(M_T_F)
        for j = 2:length(M_T_F)
            M_T_F(i,j) = M_T_F(i,j)/2;
        end
    end
end

% Display Results
if trainTest == 0
    disp('TRAIN PERFORMANCE: ');
    disp(M_TR_F);
    disp(['Classification error for training set(%) = ' num2str(100*trace(fliplr(M_TR))/sum(sum(M_TR)))]);
    disp(['-----------------------------------------------------' newline]);
    disp('TEST PERFORMANCE: ');
    disp(M_TE_F);
    damaged_frames_te = sum(sum(M_TE(:,2))); % Number of frames classified as damaged
    disp(['Number of frames classified as damaged = ' num2str(damaged_frames_te)]);
    disp(['Classification error for testing set(%) = ' num2str(100*trace(fliplr(M_TE))/sum(sum(M_TE)))]);
  
    actual_damaged_frames = sum(sum(M_TR(:,2)));
    tp_train = sum(sum(M_TR_F(2:end,2)));
    pod_train = tp_train / actual_damaged_frames;

   
    actual_damaged_frames_test = sum(sum(M_TE(:,2)));
    tp_test = sum(sum(M_TE_F(2:end,2)));
    pod_test = tp_test / actual_damaged_frames_test;
    z = 1-(damaged_frames_te/576);
    x = linspace(0,5,5);
    y = [0,pod_test,z*0.3333,z*0.3333,z*0.3333]; 
    plot(x,y)
    xlabel('JOINTS')
    ylabel('PDF')
  

   
else
    disp('TEST PERFORMANCE: ');
    disp(M_T_F);
    damaged_frames_t = sum(sum(M_T(:,2))); % Number of frames classified as damaged
    disp(['Number of frames classified as damaged = ' num2str(damaged_frames_t)]);
    disp(['Classification error(%) = ' num2str(100*trace(fliplr(M_T))/sum(sum(M_T)))]);
    actual_damaged_frames_test = sum(sum(M_TE(:,2)));
    tp_test = sum(sum(M_TE_F(2:end,2)));
    pod_test = tp_test / actual_damaged_frames_test;
    z = 1-(damaged_frames_te/576);
    x = linspace(0,5,5);
    y = [0,pod_test,z*0.3333,z*0.3333,z*0.3333]; 
    plot(x,y)
    xlabel('JOINTS')
    ylabel('PDF')
end


