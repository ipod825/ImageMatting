function A=getLaplacian1(I,consts,epsilon,winLen)
  
  if (~exist('epsilon','var') || isempty(epsilon))
    epsilon=0.0000001;
  end  
  
  if (~exist('winLen','var') || isempty(winLen))
    winLen=1;
  end     

  % # of pixels in a window
  winSize=(winLen*2+1)^2;
  % # of all index combinations in a window
  numCombo = winSize ^ 2;
  [h,w,c]=size(I);
  imgSize=w*h;
%   consts=imerode(consts,ones(winLen*2+1));
  
  winIndsM=reshape([1:imgSize],h,w);
  numWin = sum(sum(1-consts(winLen+1:end-winLen,winLen+1:end-winLen)));
  %each window contribute to numCombo score, totally sLen score
  sLen= numWin*(numCombo);  
  sInds = (1:numCombo);

  sRows=zeros(sLen ,1);
  sCols=zeros(sLen,1);
  vals=zeros(sLen,1);
  for j=1+winLen:w-winLen
    for i=winLen+1:h-winLen
      if (consts(i,j))
        continue
      end  
      winInds=winIndsM(i-winLen:i+winLen,j-winLen:j+winLen);
      winInds=winInds(:);
      winI=I(i-winLen:i+winLen,j-winLen:j+winLen,:);
      winI=reshape(winI,winSize,c);
      mu=mean(winI,1)';
      var=inv(winI'*winI/winSize-mu*mu' +epsilon/winSize*eye(c));
      
      winI=winI-repmat(mu',winSize,1);
      sVals=(1+winI*var*winI')/winSize;
      
      sRows(sInds)=reshape(repmat(winInds,1,winSize),numCombo,1);
      sCols(sInds)=reshape(repmat(winInds',winSize,1),numCombo,1);
      vals(sInds)=sVals(:);
      sInds = sInds+numCombo;
    end
  end  
  
  %sum up the score at each (i,j) belonging to the Laplacian
  A=sparse(sRows,sCols,vals,imgSize,imgSize);
  
  sumA=sum(A,2);
  A=spdiags(sumA(:),0,imgSize,imgSize)-A;
  
return


