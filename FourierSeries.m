


function [signal_out,serie_coefs] = FourierSeries(signal_in, N, fo)

    % Calculate the input signal's decomposition in Fourier series
    % Limitation: The number of harmonics that can be calculated is limited by
    % the number of point of the input signal sample. (Equivalent of
    % sample frequency limit)--> 1/(N*fo) > 2*sampling period 
    % <=> N*f0 < fs/2 = (1023*npc)/(2To)
    % period/point_number = sampling period 
    % Input:
    % - signal_in = input signal: 1 period, vector of samples
    % - N = number of harmonics to be caculated [int]
    % - fo = input signal fundamental frequency
    % Output:
    % - signal_out = output signal: input signal approximation by the harmonique sum 
    % - serie_coefs = decomposition coefficeint array (an,bn)

    number_point = size(signal_in,2);   % point_number = number of point over one period
    period = 1/fo;
    
    % Coefficient calculation
    serie_coefs = zeros(N+1,2);     % Array of coupled value (an,bn)
                                    % N lines (number of harmonics), 2 columns (for an,bn)

    % Sinus and Cosinus calculation preparation
    x = linspace(0,period,number_point); % time axis
    COS = zeros(1,number_point);
    SIN = zeros(1,number_point);

    % composante continue = offset = signal mean over a period
    serie_coefs(1,1) = mean(signal_in);
    serie_coefs(1,2) = 0;
    
    % Cumulative curve 
    signal_out = serie_coefs(1,1)*ones(1,number_point); % Composante Continue ou Offset

    for n = 1:N
        % Cos and Sin calculation
        for t = 1:number_point
            COS(t) = cos(2*pi*n*fo*x(t));
            SIN(t) = sin(2*pi*n*fo*x(t));
        end
        serie_coefs(n+1,1) = 2*mean(signal_in.*COS); %an
        serie_coefs(n+1,2) = 2*mean(signal_in.*SIN); %bn
       
        %harmonics calculation
        
        harmonic_cos = serie_coefs(n+1,1)*COS; %an
        harmonic_sin = serie_coefs(n+1,2)*SIN; %bn
       
        signal_out = signal_out + harmonic_cos + harmonic_sin;
        
    end
   
end

