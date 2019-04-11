function [ x ] = Mosaic(sim,dim,n)

%CORRESPONDING POINTS IN BOTH IMAGES SELECTED


[r1 c1 p1]=size(sim);
[r c p]=size(dim);

[spoints dpoints x y]=selectPoints(sim,dim,n);

[minpointS,mIm]=max(spoints(:,1));

overlpointS=[spoints(mIm,1),spoints(mIm,2)]; %POINT IN THE SOURCE IMAGE FROM WHERE TO START OVERLAPPING WARPED IMAGE

[maxpointD]=max(dpoints(:,1)); %CORRESPONDING Destination point for stitching

%overlpointD=[dpoints(mJm,1),spoints(mJm,2)];

diff=size(1:maxpointD,2);

b=dpoints; %VECTOR B containing co-ordinates of selected points
b=b';
b=b(:);

inc=0;

A=zeros(2*n,8);

for i=1:2:2*n
   %Fill entries in matrix A for the x-correspondance
   A(i,1)=spoints(i-inc,1);
   A(i,2)=spoints(i-inc,2);
   A(i,3)=1;
   A(i,4)=0;
   A(i,5)=0;
   A(i,6)=0;
   A(i,7)=-dpoints(i-inc,1)*spoints(i-inc,1);
   A(i,8)=-dpoints(i-inc,1)*spoints(i-inc,2);
   %Fill entries in matrix A for the y-correspondance
   A(i+1,1)=0;
   A(i+1,2)=0;
   A(i+1,3)=0;
   A(i+1,4)=spoints(i-inc,1);
   A(i+1,5)=spoints(i-inc,2);
   A(i+1,6)=1;
   A(i+1,7)=-dpoints(i-inc,2)*spoints(i-inc,1);
   A(i+1,8)=-dpoints(i-inc,2)*spoints(i-inc,2);
   inc=inc+1;
end



x=A\b; 

H=[x(1,1) x(2,1) x(3,1);x(4,1) x(5,1) x(6,1);x(7,1) x(8,1) 1]; %HOMOGRAPHY MATRIX

%TEST MAPPING
map= zeros(n,3);

for i=1:n
map(i,:)=H*[spoints(i,:),1]';
end

subplot(1,2,2),hold on;
plot(map(1,1)/map(1,3),map(1,2)/map(1,3),'O','MarkerSize',20);
plot(map(2,1)/map(2,3),map(2,2)/map(2,3),'O','MarkerSize',20);
plot(map(3,1)/map(3,3),map(3,2)/map(3,3),'O','MarkerSize',20);
plot(map(4,1)/map(4,3),map(4,2)/map(4,3),'O','MarkerSize',20);


%CORNER MAPPING

m1=H*[1 1 1]';
m2=H*[1 c 1]';
m3=H*[r 1 1]';
m4=H*[r c 1]';

%MATRICES CONTAINING TRANSFORMED CORNER CO-ORDINATES
xc=[(m1(1,1)/m1(3,1)) (m2(1,1)/m2(3,1)) (m4(1,1)/m4(3,1)) (m3(1,1)/m3(3,1)) (m1(1,1)/m1(3,1))];
yc=[(m1(2,1)/m1(3,1)) (m2(2,1)/m2(3,1)) (m4(2,1)/m4(3,1)) (m3(2,1)/m3(3,1)) (m1(2,1)/m1(3,1))];


%BOUNDS OF CORNERS
[xmax]=max(xc);
[ymax]=max(yc);
[xmin,cxx]=min(xc);
[ymin]=min(yc);

wI=zeros(size(xmin:xmax,2)-1,size(ymin:ymax,2)-1,3);

[wr wc]=size(wI);


%TRANSLATE THE VECTORS XC AND YC FOR PLOTTING IN POSITIVE AXIS
xc=xc+(size(xmin:0,2));
yc=yc+(size(ymin:0,2));

disp('This process may take a few mins...');

dim=double(dim);

%POPULATE WARPED IMAGE
for i=1:wr
    for j=1:wc
        X=H\([i-size(xmin:0,2) j-size(ymin:0,2) 1]');
        xdim=round(X(1,1)/X(3,1));
        ydim=round(X(2,1)/X(3,1));
        if(xdim>1 && ydim>1 && xdim<r && ydim<c)
            wI(i,j,1)=dim(xdim,ydim,1);
            wI(i,j,2)=dim(xdim,ydim,2);
            wI(i,j,3)=dim(xdim,ydim,3);
        end
    end
end

wI2=uint8(wI);
figure,imshow(wI2,[]),hold on
line(yc,xc);

[wr wc]=size(wI);
width=c1+wc;

%Stitching
bigimg=zeros(wr,width,3);
%rsim=imresize(sim,[r1,c1]);

%store source image
bigimg(1+50:r1+50,1:c1,1:3)=sim(1:r1,1:c1,1:3);

str=round(overlpointS(1));
str=str-30;
diff=diff-20;
endpoint=wc-str;

%store warped image
for i=1:wr
    for j=round(str/3)+1:round(endpoint/3)
        bigimg(i,(j+str-(round(str/3)+1)),1)=wI(i,j-round(str/3)+diff,1);
        bigimg(i,(j+str-(round(str/3)+1)),2)=wI(i,j-round(str/3)+diff,2);
        bigimg(i,(j+str-(round(str/3)+1)),3)=wI(i,j-round(str/3)+diff,3);
    end
end

%Result image 
bigimg=uint8(bigimg);
figure,imshow(bigimg);

end

