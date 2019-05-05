function [y]=bandpassfilterOne(input,n,order,fc1,fc2,fps)
    wc1=(fc1/fps)*2*pi;
    wc2=(fc2/fps)*2*pi;
    y=0;
    M=order;
    for i=1:M
        if(i==M/2)
            hd=(wc2-wc1)/pi;
        else
            hd=(sin(wc2*(i-M/2))-sin(wc1*(i-M/2)))/(pi*(i-M/2));
        end
        h=hd*window(i,M);
%         h = hd;
        y=y+h*input(n-i+1);
    end
end

function w=window(n,M)
       if (n >= 0 && n <= M)
           w = 0.54 - 0.46*cos(2 * pi*n / M);
       else
           w = 0;
       end
end