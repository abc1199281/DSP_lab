function [output]=bandpassfilter(input,order,fc1,fc2,fps)
    wc1=(fc1/fps)*2*pi;
    wc2=(fc2/fps)*2*pi;
    output=zeros(length(input)-order+1,1);
    for j=1:length(output)
        y=0;
        M=order;
%         if (j>=order)
%             M=order;
%         else
%             M=j;
%         end
        for i=1:M
            if(i==M/2)
                hd=(wc2-wc1)/pi;
            else
                hd=(sin(wc2*(i-M/2))-sin(wc1*(i-M/2)))/(pi*(i-M/2));
            end
            h=hd*window(i,M);
            y=y+h*input(order+j-i);
        end
        output(j)=y;
    end
end

function w=window(n,M)
       if (n >= 0 && n <= M)
           w = 0.54 - 0.46*cos(2 * pi*n / M);
       else
           w = 0;
       end
end