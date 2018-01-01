function [corners] = Corners(image, threshold)

    imgin = imread(image);
    imggray = rgb2gray(imgin);
    sz = size(imggray);
    ydimension = sz(1,1);
    xdimension = sz(1,2);
    %   colors = sz(1,3);
    
    hx = [1, 0, -1; 2, 0, -2; 1, 0, -1];
    hy = hx';
    
    [dx, dy] = meshgrid(-1:1, -1:1);
    
    px = [1, 0, -1; 1, 0, -1; 1, 0, -1];
    py = px';    
    count = 0;
    rows = [];
    columns = [];
    for i = 1:xdimension
        for j = 1:ydimension
            
            window = zeros(3);
            xpl = 1;
            xmi = -1;
            ypl = 1;
            ymi = -1;
            
            if (i == 1)
                xmi = xmi*-1;
            end
            if (j == 1)
                ymi = ymi*-1;
            end
            if (i == xdimension)
                xpl = xpl*-1;
            end
            if (j == ydimension)
                ypl = ypl*-1;
            end
            
            window(1,1) = imggray(j+ymi, i+xmi);
            window(1,2) = imggray(j+ymi, i);
            window(1,3) = imggray(j+ymi, i+xpl);

            window(2,1) = imggray(j, i+xmi);
            window(2,2) = imggray(j, i);
            window(2,3) = imggray(j, i+xpl);

            window(3,1) = imggray(j+ypl, i+xmi);
            window(3,2) = imggray(j+ypl, i);
            window(3,3) = imggray(j+ypl, i+xpl);
            
            Ix = conv2(double(window), px, 'same');
            Iy = conv2(double(window), py, 'same');
    
            Ix2 = Ix.^2;
            Iy2 = Iy.^2;
            Ixy = Ix.*Iy;
    
            A = [Ix2, Ixy; Ixy, Iy2];
    
            values = eig(A);
            if (min(values) > threshold)
                count = count + 1;
                rows = [rows, j];
                columns = [columns, i];
            end

%             Ix = window.*hx;
%             Iy = window.*hy;
%             
%             A(1,1) = A(1,1) + sum(Ix)
            
        end
    end
    corners = [rows; columns];
    count
    figure;imshow(imgin), hold on,
    plot(columns,rows,'ys'), title('Corners');
end