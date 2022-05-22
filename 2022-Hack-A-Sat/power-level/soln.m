fid = fopen("powerlevel.dat", "r");
data = fread(fid, "single");

fs = 100e3;
n = 100e3;
fprintf("Sample Rate = %d (Hz)", fs);
fprintf("Sample Size = %d", n);

sig_I = data(1:2:end);
sig_Q = data(2:2:end);
IQ_data = sig_I + 1j * sig_Q;

figure(1);
plot(real(IQ_data(1:1000)), "b");
hold on;
plot(imag(IQ_data(1:1000)), "g");
legend("Inphase Signal", "Quadrature Signal");
title("IQ Data for First 1000 Points of Acquired Signal");
xlabel("Sample Number");
ylabel("Voltage");

% Create a periodogram spectrum with a Hamming window to visualize the max
% frequency
figure(2);
w = hamming(length(IQ_data));
periodogram(IQ_data, w, [], fs, "centered");

% Actually determine the max frequency using the periodogram
[pxx, F] = periodogram(IQ_data, w, [], fs, "power");
[pwrest, idx] = max(pxx);
fprintf("Frequency = %3.1f (Hz)\n", F(idx));

SNR = snr(real(IQ_data), fs);
fprintf("SNR = %3.2f (dB)\n", SNR);