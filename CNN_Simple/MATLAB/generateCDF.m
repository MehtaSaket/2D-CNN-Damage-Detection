function  [sizes,isSingle] = generateCDF(CDFNAME,FID,DATADIR,CDFDIR,dataFile,nClasses,frameSize,percentageTrain,normalized,shuffled,trainTest)

load([DATADIR dataFile '.mat']);

sizes = zeros(nClasses,1);
for i = 1:nClasses
    try
        eval(['sizes(' num2str(i) ') = length(c' num2str(i) ');']);
    catch
        eval(['sizes(' num2str(i) ') = 0;']);
    end
end

N = sum(sizes)/frameSize;

inpV = [];
outV = [];

for i = 1:nClasses
    try
        inpV = [inpV;eval(['c' num2str(i)])];
    catch
    end
end

for i = 1:nClasses
    for j = 1:sizes(i)/frameSize
        oo = zeros(nClasses,1);
        oo(i) = 1;
        outV = [outV;oo];
    end
end

if normalized == 1
    [inpV] = normalize(inpV,frameSize,N);
end

if shuffled == 1
    [inpV,outV] = shuffleCol(inpV,outV,frameSize,nClasses,N);
end

trainN = floor(percentageTrain*N);
testN = N - trainN;

if (trainN == 0 || testN == 0) && trainTest == 1
    trVec = [FID;max([trainN testN]);frameSize;1;nClasses;outV(1:nClasses*max([trainN testN]));inpV(1:frameSize*max([trainN testN]))];
    teVec = trVec;
    isSingle = 1;
else
    trVec = [FID;trainN;frameSize;1;nClasses;outV(1:nClasses*trainN);inpV(1:frameSize*trainN)];
    teVec = [FID;testN;frameSize;1;nClasses;outV(trainN*nClasses+1:end);inpV(trainN*frameSize+1:end)];
    isSingle = 0;
end

ftr = fopen([CDFDIR CDFNAME '_' num2str(FID) '_train.cdf'],'w');
fte = fopen([CDFDIR CDFNAME '_' num2str(FID) '_test.cdf'],'w');

fwrite(ftr,trVec,'float');
fwrite(fte,teVec,'float');

fclose(ftr);
fclose(fte);

end

