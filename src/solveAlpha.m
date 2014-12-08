function alpha=solveAlpha(img,consts_map,consts_vals,varargin)
  global algorithm;
  
  [h,w,c]=size(img);
  imgSize=w*h;
  
  D=spdiags(consts_map(:),0,imgSize,imgSize);
  lambda=100;
  A=getLaplacian1(img,consts_map,varargin{:});
  
  if (strcmp(algorithm,'Close Form'))
  tic    
  x=(A+lambda*D)\(lambda*consts_vals(:));
  toc
  fprintf('Close Form Algorithm\n');
  else
  tic    
  A_m = A+lambda*D;
  beta = lambda*consts_vals(:);
  x = consts_vals(:);
  x = conjugrad(A_m,beta,x);
  toc
  fprintf('CG Algorithm\n');
  end
  
  %{
  ak = cell(h,w); 
  bk = cell(h,w); 
  Lp = zeros(h,w);
    
  win_size = 1;
  epsilon=0.0000001;
  neb_size=(win_size*2+1)^2;
  
  x = zeros(size(consts_vals(:),1),1);
  r = lambda*consts_vals(:);
  pii = lambda*consts_vals;
  rsold=r'*r;
  
  
  for time=1:10^(4)
    
     for i=1+win_size:h-win_size
        for j=win_size+1:w-win_size
        
           winI=img(i-win_size:i+win_size,j-win_size:j+win_size,:);
           winI=reshape(winI,neb_size,c);
           win_mu=mean(winI,1)';
           win_pii = pii(i-win_size:i+win_size,j-win_size:j+win_size);
           win_pii = reshape(win_pii,neb_size,1);
           pk_mu = mean(win_pii,1)';
           s = winI.*(repmat(win_pii,1,c));
           tsum = sum(s,1)/(neb_size);
           win_var = inv(winI'*winI/neb_size-win_mu*win_mu' +epsilon/neb_size*eye(c));
           ak{i,j} = win_var*(tsum' - win_mu.*pk_mu);
           bk{i,j} = pk_mu - (ak{i,j}')*win_mu;      
        end
     end

     for i=1:h
        for j=1:w
           win_ak = ak(max(i-win_size,1+win_size):min(i+win_size,h-win_size),max(j-win_size,1+win_size):min(j+win_size,w-win_size));       
           win_bk = bk(max(i-win_size,1+win_size):min(i+win_size,h-win_size),max(j-win_size,1+win_size):min(j+win_size,w-win_size));          
           sumak = zeros(3,1);
           sumbk = 0;
           for m = 1: size(win_ak,1)
              for n = 1:size(win_ak,2)
                 sumak(1,1) = sumak(1,1) + win_ak{m,n}(1);
                 sumak(2,1) = sumak(2,1) + win_ak{m,n}(2);
                 sumak(3,1) = sumak(3,1) + win_ak{m,n}(3);
                 sumbk = sumbk + win_bk{m,n};               
              end
           end
           Lp(i,j) = (neb_size)*pii(i,j) - sumak(1,1)*img(i,j,1) - sumak(2,1)*img(i,j,2) - sumak(3,1)*img(i,j,3) - sumbk;        
        end
     end

     p = pii(:);
     Ap = Lp(:) + lambda*D*p;     
     alpha=rsold/(p'*Ap);
     x=x+alpha*p;
     r=r-alpha*Ap;
     rsnew=r'*r;
     if sqrt(rsnew)<1e-10
           break;
     end
     p=r+rsnew/rsold*p;
     rsold=rsnew;
     pii = reshape(p,h,w);
     fprintf('Time = %d\n',time);
  end
  %}
  alpha=max(min(reshape(x,h,w),1),0);