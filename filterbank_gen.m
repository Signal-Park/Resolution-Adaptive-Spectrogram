function [filter_bank] = filterbank_gen(numFilter, fmax, nfft, cornerFreq)
% Generate FilterBank for RA Spectrogram

    % Maximum scale value
    S_max = scaleFun(fmax, cornerFreq);        

    % Nonlinear scale points for filterbank design
    NL_points = linspace(0, S_max, numFilter + 2);  

    % Linear scale points obtained by applying inverse scaling
    L_points = invScaleFun(NL_points, cornerFreq);  

    % Create filterbank matrix
    FFTbin = floor((nfft + 1) * L_points / (2 * fmax));    
    filter_bank = zeros(numFilter, floor(nfft / 2));

    for m = 2:(numFilter) + 1
        % Ascending part of filter
        for k = FFTbin(m-1) + 1:FFTbin(m)
            filter_bank(m-1, k) = (k - FFTbin(m-1)) / (FFTbin(m) - FFTbin(m-1));
        end

        % Descending part of filter
        for k = FFTbin(m) + 1:FFTbin(m+1)
            filter_bank(m-1, k) = (FFTbin(m+1) - k) / (FFTbin(m+1) - FFTbin(m));
        end
    end

    function D = scaleFun(hz, cornerFreq)
        D = cornerFreq / log10(2) * log10(1 + hz / cornerFreq);
    end

    function hz = invScaleFun(D, cornerFreq)
        hz = cornerFreq * (10.^(D / (cornerFreq / log10(2))) - 1);
    end

end
