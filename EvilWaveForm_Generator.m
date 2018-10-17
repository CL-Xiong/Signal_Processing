


function [signal,fs,number_chip,npt] = EvilWaveForm_Generator(waveform_type,PRN_vector, chip_rate,npc,duration )

    % Evil Wave Form Signal Generator function
    %   Generate the three types of Evil Wave Form: ringing, lag effect,
    %   both, and the perfect signal
    %
    %   Input:
    % -waveform_type: 'perfect','ringing','lag','both' [char]
    % -PRN_vector: PRN code vector
    % -chip_rate = number of chip per seconde [int]
    % -npc: number of point per chip [int]
    % -duration: [second] [double]
    %   Output:
    % -signal: (Nx1) vector of values, temporal representation
    % -fs: "sample frequency" equivalent [Hz]
    % -number_chip: number of chip
    % -npt: total number of point

    %%%%%%%%%%%%%%%%%%%%%%
    % Connexe parameters %
    %%%%%%%%%%%%%%%%%%%%%%
    number_chip = duration * chip_rate;             % number of chip
    npt = npc * number_chip + 1;                        % total number of point
    fs = npt/duration;                              % "sample frequency" equivalent

    %%%%%%%%%%%%%%%%%%%%%%
    % Signal Calculation %
    %%%%%%%%%%%%%%%%%%%%%%
    
    % let's suppose the number of chip = PRN_vector length
    if number_chip == length(PRN_vector)
        disp('number of chip = PRN_vector length');
    else
        disp('number of chip != PRN_vector length');
    end
    
    signal = ones(1,npt);
    
    if strcmp(waveform_type,'perfect')
        for i = 1:length(PRN_vector)
            if PRN_vector(i) == -1
                signal((i-1)*npc+1:i*npc) = -signal((i-1)*npc+1:i*npc);
            end
        end
    elseif strcmp(waveform_type,'ringing')
        % Check:
        % N*f0 < fs/2 = (1023*npc)/(2To)
        N = 48000;          % Number of harmonic
        Frequency = 1000;   % PRN period = one sequence
        
        % Fourier Serie Decomposition function call
        [signal,~] = FourierSeries(signal,N,Frequency);
        
    elseif strcmp(waveform_type,'lag')
        duty = 0.6;
        np_chip1 = round(2*npc*duty); % New middle of the chip duo
        lag = np_chip1 - npc;
        for i = 1:2:(length(PRN_vector)-2)
            chip1_b = (i-1)*npc+1
            chip1_e = i*npc + lag
            chip2_b = i*npc+1 + lag;
            chip2_e = (i+1)*npc;
            % First part of the period
            if PRN_vector(i) == -1
                signal(chip1_b:chip1_e) = -signal(chip1_b:chip1_e);
            end
            % Second part of the period
            if PRN_vector(i+1) == -1
                signal(chip2_b:chip2_e) = -signal(chip2_b:chip2_e);
            end
        end
    elseif strcmp(waveform_type,'both')
    
    else
        disp('Signal wave form incorrect');
    end

end