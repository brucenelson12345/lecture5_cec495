% Bruce Nelson
% Lecture 5

close all; clear all; clc;

StartingFrame = 1; % 1
EndingFrame = 936; % 936

field1 = 'centroid_x'; value1 = [];
field2 = 'centroid_y'; value2 = [];

% Structure for containg the 3 balls
ball(3) = struct(field1, value1, field2, value2);

for k = StartingFrame : EndingFrame-1
    
    % read in current image
    rgb = imread(['juggle/img', ...
        sprintf('%2.3d',k),'.jpg']);
        
    % creates the threshold mask
    img1 = createMask2(rgb);
    
    % opens the balls as to elimnate noise and small balls
    se = strel('disk',20);
    img1 = imdilate(img1, se);
    
    [labels,number] = bwlabel(img1,8);
    
    Istats = regionprops(labels,'basic','Centroid');
    [values, index] = sort([Istats.Area], 'descend');
    
    % first frame case
    if k == 1
        for b = 1:1:3
            ball(b).centroid_x = [ball(b).centroid_x Istats(b).Centroid(1)];
            ball(b).centroid_y = [ball(b).centroid_y Istats(b).Centroid(2)];
        end
    
     
    elseif number >= 3 % 3 or more objects
        for b = 1:1:3
            for d = 1:1:3
                % may switch b,d so that its (d,b)
                dist(b,d) = hypot(abs(ball(b).centroid_x(end) - Istats(index(d)).Centroid(1)), ...
                    abs(ball(b).centroid_y(end) - Istats(index(d)).Centroid(2)));
            end
        end
        
        % calculate minium distance
        [minVal, minIndex] = min(dist);
        
        % calculates the centroids for each ball
        for b = 1:1:3
            ball(b).centroid_x = [ball(b).centroid_x Istats(minIndex(b)).Centroid(1)];
            ball(b).centroid_y = [ball(b).centroid_y Istats(minIndex(b)).Centroid(2)];
        end

    end
    
    imshow(rgb);
    hold on;
    scatter(ball(1).centroid_x, ball(1).centroid_y, 'r');
    hold on;
    scatter(ball(2).centroid_x, ball(2).centroid_y, 'g');
    hold on;
    scatter(ball(3).centroid_x, ball(3).centroid_y, 'b');
    pause(.001);
    
end

imshow(rgb);
hold on;
scatter(ball(1).centroid_x, ball(1).centroid_y, 'r');
hold on;
scatter(ball(2).centroid_x, ball(2).centroid_y, 'g');
hold on;
scatter(ball(3).centroid_x, ball(3).centroid_y, 'b');