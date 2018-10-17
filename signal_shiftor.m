function [ signal_out ] = signal_shiftor( signal_in, shift )
% Shift a periodic signal of 'shift' index
% The signal must be one period long
% shift < 0 means aheading the signal
% shift > 0 means delaying the signal
% shift is a number of point

    L = length(signal_in);
    if shift > L
        disp('Invalid shift > length signal');
    else   
        if shift < 0 && shift ~= -L
            shift = abs(shift);
            % shift on the left <=> early signal <=> ahead
            signal_out = [signal_in(shift+1:L) signal_in(1:shift)];
        elseif shift > 0 && shift ~= +L
            % shift on the right <=> late signal <=> delayed
            signal_out = [signal_in(L-shift+1:L) signal_in(1:L-shift)];
        else
            signal_out = signal_in;
        end
    end 
end

