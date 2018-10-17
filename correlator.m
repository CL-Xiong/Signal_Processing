function [ correlation ] = correlator( signal_x, signal_y )

    Lx = length(signal_x);
    Ly = length(signal_y);
    correlation = zeros(1,2*Lx-1);
    if Lx ~= Ly
        disp('Signals x and y are not the same lenght');
    else
        for k = (-Lx+1):(Lx-1)
            signal_y = signal_shiftor(signal_y,k);
            correlation(k+Lx) = sum(signal_x.*signal_y);
        end
    end
end

