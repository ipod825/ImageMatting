function paintTypeChange(flag)

    global paintFlag clickTime;

    paintFlag = flag;
    hfig = gcf;
    hold on;
    set(hfig,'WindowButtonDownfcn',@dataout);
    clickTime = 0;
    set(hfig,'userdata',[]);
end

function datain(imagefig, varargins)
    global paintFlag penx peny;

    hold on;
    temp = get(gca,'currentpoint');
    pr = temp(1,2)+penx;
    pc = temp(1,1)+peny;
    set(gcf,'userdata',[get(gcf,'userdata'); pr(:), pc(:)]);

    % FG or BG seed?
    if(paintFlag == 0)
          plot(pc(:),pr(:),'.r');
    elseif(paintFlag == 1)
          plot(pc(:),pr(:),'.b');
    end
end

function dataout(imagefig,varargins)
    global clickTime paintFlag  fgpixels bgpixels imgw imgh;
    
    if(clickTime == 0)
        set(gcf,'WindowButtonMotionFcn',{@datain});
    elseif(clickTime == 1)
        set(gcf,'WindowButtonMotionFcn',[]);
        temp=get(gcf,'userdata');
        coords = floor(temp(:,1:2));
        coords = union(coords,coords,'rows');
        [out tmp] = find(coords(:,1)>=imgh);
        if(~isempty(out))
            coords(out,:)=[];
        end
        [out2 tmp] = find(coords(:,2)>=imgw);
        if(~isempty(out))
            coords(out2,:)=[];
        end
        [out3 tmp] = find(coords(:,1)<=1);
        if(~isempty(out))
            coords(out3,:)=[];
        end
        [out4 tmp] = find(coords(:,2)<=1);
        if(~isempty(out))
            coords(out4,:)=[];
        end
        
        
        if(paintFlag == 0)
             fgpixels = vertcat(fgpixels,coords);
        elseif(paintFlag == 1)
             bgpixels = vertcat(bgpixels,coords);
        end
    end
    
    clickTime = mod((clickTime+1),2);
end

