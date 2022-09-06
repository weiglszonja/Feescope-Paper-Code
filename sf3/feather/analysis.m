
% calculates radial averages of illumination images and plots them
% concurrently



w = 808;
h = 608;

dpixel = 1.68;
rLength = 500;

I=[];
I(:,:,1) = repmat(1:w,h,1);
I(:,:,2) = repmat((1:h)',1,w);




axicon = double(imImport('axicons/rgb2021-01-29T16_31_30.png'));
led = double(imread('led/feather.png'));
ref = double(imImport('reference/rgb2021-01-29T16_54_50.png'));
images = cat(4,axicon,led,ref);

for i = 1:3
    iIm = images(:,:,:,i);
    means = squeeze(sum(I .* repmat(iIm,1,1,2), [1,2])/sum(iIm(:)));
    xmean = means(1);
    ymean = means(2);


    xgrid = dpixel*(I(:,:,1) - xmean);
    ygrid = dpixel*(I(:,:,2) - ymean);

    rAvg=zeros(rLength,1);
    rN=zeros(rLength,1);
    rDist=round(sqrt(xgrid.^2+ygrid.^2));
    rDistV=rDist(:);

    imVec = iIm(:);

    for j=1:numel(rDistV)
        r=rDistV(j);
        if r<numel(rAvg)
            rAvg(r+1)=rAvg(r+1)+imVec(j);
            rN(r+1)=rN(r+1)+1;
        end
    end

    rAvg=rAvg./rN;
    if isnan(rAvg(1))
        rAvg(1)=rAvg(2);
    end

    plotVec = smoothdata(rAvg,'movmedian',3);
    plot(plotVec/prctile(plotVec,99));
    xlim([0,500]);
    ylim([0,1.1]);
    set(gca,'fontsize',18);
    set(gca,'tickdir','out');
    hold on;
end