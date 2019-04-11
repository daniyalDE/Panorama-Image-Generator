function [spoints,dpoints,x,y]=selectPoints(sim,dim,n,direction)
% funcion takes as input a left image and a right
% and allow user to select n number of corresponding points 
% from both images...
%input:
% sim= source image (the image to warp)
% dim= destination image (the )
% n= number of corresponding points to choose
% Output: Two matrices containing coordinates of selected points.
% spoints = n x 2 matrix for the point cooridnates from the source image (can be left or right)
% dpoints = n x 2 matrix for the point cooridnates from the destination image (can be )
% Written BY: Sibt ul Hussain
if nargin < 3
	n=4; % by default 4 corresponding points are selected from the image...
end

%sim=im2uint8(sim);
%dim=im2uint8(dim);
str=sprintf('Select %d Corresponding Points ',n);
figure(1),
subplot(1,2,1),imshow(sim),title(['Source Image: ' str]);
subplot(1,2,2),imshow(dim),title(['Target Image: ' str]);
spaceplots([0 0 0 0], [.001 .001]);hold on
disp(str);

if verLessThan('matlab', '7.5')
        disp('Older Matlab version Using ginput en lieu newer one');
      [x, y] = ginput(n*2);

else
	[x, y] = ginputc(n*2,'ShowPoints', true, 'ConnectPoints',false);
end
hold off;

%clf;
plotPoints(sim,dim,x,y)
spaceplots([0 0 0 0], [.001 .001]);

spoints=[x(1:2:end) y(1:2:end)];
dpoints=[x(2:2:end) y(2:2:end)];
%checkPoints(sim,spoints);
%checkPoints(dim,dpoints);


function checkPoints(img,points)
% function display the given points on the input image for visual
% inspection
h=figure(220);
imshow(img,[]);
count=0;
for k=1:size(points,1)
    content = sprintf('%d',count+1);
    
    text(points(k,2),points(k,1),content,'FontSize',20,'Color','r');
    count=count+1;
end
hold on,
plot(points(:,2),points(:,1),'g*'),hold off
disp('Press Key to Close the Window and Continue ');
pause;


function plotPoints(sim,dim,x,y)
subplot(1,2,1),imshow(sim),hold on, plot(x(1:2:end),y(1:2:end),'r*'),
count=0;
for k=1:2:numel(x);
    content = sprintf('%d',count+1);
    text(x(k),y(k),content,'FontSize',20,'Color','b');
    count=count+1;
end
hold off
subplot(1,2,2),imshow(dim),hold on,plot(x(2:2:end),y(2:2:end),'r+'),
count=0;
for k=2:2:numel(x)
    content = sprintf('%d',count+1);
    text(x(k),y(k),content,'FontSize',20,'Color','r');
    count=count+1;
end
hold off

% close(h);
