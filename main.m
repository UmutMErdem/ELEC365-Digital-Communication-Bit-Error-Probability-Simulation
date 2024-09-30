% option a -> for equal probability
syms x; N0 = [];
SNR = 0:15; % SNRdb values

%{ 
Using the solve command according to the given SNR values,
N0 values are found in vector form for 10*log10(1/N0) = 0-15. 
%}
for i=0:15
    N0= double([N0, solve(10.*log10(1./x)== i, x)]);
end

% The amount of bits to be produced for each SNR value N = 10,000,000
N = 1e7;

% Pb = Q(1/√N0), is found with the qfunc function.
Pb_theoretical = qfunc(sqrt(1./N0));

%{ 
With the randi function, bits were obtained for each SNRdb value 
in a 16x10^7 matrix size with uniform distribution and equal probability, 
giving a value of 0 or 1.
%}
bits = randi([0, 1], 16, N);

%{ 
In the ai variable, according to the theoretically found a1=1 and a2=-1 
values, the 0 and 1 values created in the bits variable are given -1 value
instead of 0. The created variable ai contains equally probable values 
1 and -1 and has a size of 16x10 martis.
%}
ai = ones(16, N);
ai(find(bits == 0)) = -1;

%{
The randn function was used when calculating n0 Gaussian noise for each 
SNR value. randn function is a function that produces random values with 
mean 0 and standard deviation 1. Since the variance we found theoretically 
is σ0^2=N0, its standard deviation is σ0=√N0. Accordingly, when calculating 
n0 gaussian noise, its standard deviation should be √N0. To do this, based 
on the random variable equation Y=α*X, it can be said that μy = α*μx and 
σy^2 = α^2*σx^2. Accordingly, α=√N0 was found and the equation 
n0 = √N0*randn() was used. The n0 gaussian noise variable created is a 
matrix of size 16x10^7.
%}
n0 = [];
for i=1:16
    n0 = [n0; sqrt(N0(i)).*randn(1,N)];
end

%{
With the created matrices ai and n0, z = ai+n0 was created.
z is a 16x10^7 matrix.
%}
z = ai + n0;
gama = 0; % theoretically, γ0(gamma) = 0.

bit_err1 = [];
%{
After the z matrix is found, the decision process is performed for 
z>γ0(gamma) and z<γ0(gamma). According to this; It has been determined 
that the bit is transmitted incorrectly when the values of the ai variable 
at that index are -1 for the indices where the z>γ0(gamma) condition is 
true, and when the values of the ai variable at that index are 1 for the 
indices where the z<γ0(gamma) condition is true. This process was found 
for each of the SNRdb values (0-15) and the total erroneous bits were 
written to the bit_err variable. Thus, the bit_err variable was created in 
the form of a 16x1 vector.
%}
for i=1:16
    h1 = z(i,:); h2= ai(i,:);
    cond1 = sum(h2(find(h1>gama))==-1);
    cond2 = sum(h2(find(h1<gama))==1);
    bit_err1 = [bit_err1; (cond1+cond2)];
end

semilogy(SNR, Pb_theoretical, "bo-",LineWidth=1.5);
hold on;
semilogy(SNR, bit_err1./N, 'r--',LineWidth=1.5);
hold off;
legend("Theoretical BER curve","Simulation BER curve");
xlabel("SNR (db)");
ylabel("Pb");
title('P(1)=P(0)=1/2 | Theoretical BER curve vs. Simulation BER curve');
%% option b -> for P(1)=1/4, P(0)=3/4
syms x; N0 = [];
SNR = 0:15; % SNRdb values

%{ 
Using the solve command according to the given SNR values,
N0 values are found in vector form for 10*log10(1/N0) = 0-15.  
%}
for i=0:15
    N0= double([N0, solve(10.*log10(1./x)== i, x)]);
end

% The amount of bits to be produced for each SNR value N = 10,000,000
N = 1e7;

%{
theoretically, Pb = [1-Q((0,5493*N0-1)/√N0)]*(1/4) + Q((0,5493*N0+1)/√N0)*(3/4)
was found and the Q operation was performed with the qfunc function.
%}
Pb_theoretical = (1 - qfunc((0.55*N0 - 1) ./ sqrt(N0))) * 1/4 + qfunc((0.55*N0 + 1) ./ sqrt(N0))*3/4;

%{ 
With the randsrc function, bits were obtained for each SNRdb value in a 
matrix size of 16x10^7, which randomly gives the value 1 with a probability 
of 1/4 and the value of 0 with a probability of 3/4.
%}
bits = randsrc(16, N, [1,0;1/4,3/4]);

%{ 
In the ai variable, according to the theoretically found a1=1 and a2=-1 
values, the 0 and 1 values created in the bits variable are given -1 value 
instead of 0. The created variable ai contains the values 1 and -1 with 
different probabilities and has a size of 16x10 martis.
%}
ai = ones(16, N);
ai(find(bits == 0)) = -1;

%{
The randn function was used when calculating n0 Gaussian noise for each 
SNR value. randn function is a function that produces random values with 
mean 0 and standard deviation 1. Since the variance we found theoretically 
is σ0^2=N0, its standard deviation is σ0=√N0. Accordingly, when calculating 
n0 gaussian noise, its standard deviation should be √N0. To do this, based 
on the random variable equation Y=α*X, it can be said that μy = α*μx and 
σy^2 = α^2*σx^2. Accordingly, α=√N0 was found and the equation 
n0 = √N0*randn() was used. The n0 gaussian noise variable created is a 
matrix of size 16x10^7.
%}
n0 = [];
for i=1:16
    n0 = [n0; sqrt(N0(i)).*randn(1,N)];
end

%{
With the created matrices ai and n0, z = ai+n0 was created.
z is a 16x10^7 matrix.
%}
z = ai + n0;

% theoretically, γ0(gamma) = 0.5493*N0.
% γ0(gamma) has a matrix size of 1x16.
gama = 0.55*N0;

%{
After the z matrix is found, the decision process is performed for 
z>γ0(gamma) and z<γ0(gamma). According to this; It has been determined that 
the bit is transmitted incorrectly when the values of the ai variable at 
that index are -1 for the indices where the z>γ0(gamma) condition is true, 
and when the values of the ai variable at that index are 1 for the indices 
where the z<γ0(gamma) condition is true. This process was found provided 
that the γ0(gamma) value was different for each SNRdb values (0-15) and the 
total erroneous bits were written to the bit_err variable. Thus, the 
bit_err variable was created in the form of a 16x1 vector.
%}
bit_err = [];
for i=1:16
    h1 = z(i,:); h2= ai(i,:);
    cond1 = sum(h2(find(h1>gama(i)))==-1);
    cond2 = sum(h2(find(h1<gama(i)))==1);
    bit_err = [bit_err; (cond1+cond2)];
end

semilogy(SNR, Pb_theoretical, "b--",LineWidth=1.5);
hold on;
semilogy(SNR, bit_err./N, 'go-',LineWidth=1.5);
hold off;
legend("Theoretical BER curve","Simulation BER curve");
xlabel("SNR (db)");
ylabel("Pb");
title('P(1)=1/4 and P(0)=3/4 | Theoretical BER curve vs. Simulation BER curve');