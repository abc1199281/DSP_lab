function quantized_x = Quantizing(x,B,X_m)
    % The signals should be zero means

    delta = X_m/(2^B);
    lower_bound = -1*X_m;
    quantized_x = zeros(1,length(x));
    
    for i = 1:length(x)
        index = round((x(i)-lower_bound)/delta);
        if index == 2^(B+1)
            index = 2^(B+1)-1;
        elseif index <= 0
             index = 0;
        end
        quantized_x(i) = index*delta+lower_bound;
    end
end