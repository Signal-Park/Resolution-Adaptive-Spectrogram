function [RASPEC, energyDist] = generateRASpectrogram(SPEC, numFilter, nfft, fmax)
% Generate RA Spectrogram
% - RASPEC: Resultant RA spectrogram
% - energyDist: Energy distribution along the frequency domain

% Convert spectrogram to logarithmic scale (in dB)
logSPEC = 10*log10(SPEC);

% Calculate energy distribution across the frequency domain
energyDist = sum(logSPEC, 2);

% The step to detect the negative and positive corner frequencies.
% To run this function, the Signal Processing Toolbox is required.
% If the toolbox is unavailable, you can manually set the cornerFreq value as an alternative.
fcs = findchangepts(energyDist, MaxNumChanges=2, Statistic="rms");

% Choose corner frequency
cornerFreq = 2 * fmax / (nfft - 1) * max(abs(nfft / 2 - fcs));

% Generate filterbank based on the calculated corner frequency
[filter_bank] = filterbank_gen(numFilter, fmax, nfft, cornerFreq);

% Split spectrogram into negative and positive frequencies
% - SPEC_neg: Negative frequency components (lower half of the spectrum)
% - SPEC_pos: Positive frequency components (upper half of the spectrum)
SPEC_neg = flip(SPEC(1:nfft/2, :));
SPEC_pos = SPEC(nfft/2+1:nfft, :);

% Apply filterbank to both negative and positive frequency components
SPEC_neg = filter_bank * SPEC_neg;
SPEC_pos = filter_bank * SPEC_pos;

% Construct RA spectrogram by concatenating negative and positive frequency components
RASPEC = [flip(SPEC_neg); SPEC_pos];

end
