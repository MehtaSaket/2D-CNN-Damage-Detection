function [aa,bb] = shuffleCol(a,b,frameSize,nClasses,totSamples )

k = randperm(totSamples,totSamples);

for i = 1:1:totSamples
    for j = -frameSize+1:1:0
        aa(frameSize*k(i)+j) = a(frameSize*i+j);
    end
end

for i = 1:1:totSamples
    for j = -nClasses+1:1:0
        bb(nClasses*k(i)+j) = b(nClasses*i+j);
    end
end

aa = aa';
bb = bb';

end

