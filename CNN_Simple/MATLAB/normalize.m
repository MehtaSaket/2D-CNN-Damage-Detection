function aa = normalize(a,frameSize,totSamples)

aa = zeros(size(a));

for i = 1:totSamples
    s1 = i*frameSize - frameSize +1;
    sf = i*frameSize;
    
    ak = a(s1:sf);
    maxVec = max(ak);
    minVec = min(ak);

    ak = ((ak-minVec)./(maxVec-minVec) - 0.5 ) *2;
    
    aa(s1:sf) = ak;
end