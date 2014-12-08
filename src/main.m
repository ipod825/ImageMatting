function main(uihandles, fgpixels, bgpixels)
    img = double(uihandles.img)/255;
    [h, w, c] = size(img);
    constMap = logical(zeros(h, w));
    constVals = zeros(h, w);
    fginds = [sub2ind([h, w], fgpixels(:,1)', fgpixels(:,2)')];
    bginds = [sub2ind([h, w], bgpixels(:,1)', bgpixels(:,2)')];
    constInds = [fginds, bginds];

    constMap(constInds)=1;
    constVals(fginds)=1;
    
    levelNum=2;
    active_levelNum=2;
    thr_alpha=0.05;
    epsilon=[];
    winSize=[];


    fprintf('calcualte alpha\n');
    alpha=solveAlphaC2F(img, constMap, constVals, levelNum,...
                     active_levelNum, thr_alpha, epsilon, winSize);
            
    figure, imshow(alpha);
    drawnow;
    fprintf('solve F/B\n');
    [F,B]=solveFB(img,alpha);

    figure;
    imshow([F.*repmat(alpha,[1,1,3]),B.*repmat(1-alpha,[1,1,3])]);
end