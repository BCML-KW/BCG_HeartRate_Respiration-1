loadPVDF = readtable('(190711)PVDF���赥����.xlsx','Range','A1:F4953');
PVDFdata = table2array(loadPVDF);
t = PVDFdata(1:4500,1)';
t_sec = PVDFdata(1:4500,2)';
ResStop = PVDFdata(1:4500,3)';
ResLight = PVDFdata(1:4500,4)';
ResDeep = PVDFdata(1:4500,5)';
ResMove = PVDFdata(1:4500,6)';

Fs = 250;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
% L = 4500;             % Length of signal
% t = (0:L-1)*T;        % Time vector x


Res_filter = designfilt('bandpassfir','FilterOrder',400, ...
         'CutoffFrequency1',0.16,'CutoffFrequency2',0.66, ...
         'SampleRate',500); %ȣ�� ���� ����
     
HR_filter = designfilt('bandpassfir','FilterOrder',400, ...
         'CutoffFrequency1',0.83,'CutoffFrequency2',2.5, ...
         'SampleRate',250);  % �ɹ� ���� ����
     
     % % RES MOVE Filter
     k_end = length(ResMove)/(10*Fs);
for k = 0:1:k_end
    if(length(ResMove) < (k+1)*10*Fs)
       break;
        ResMove5s = ResMove(k*10*Fs+1 : end);
    else
        ResMove5s = ResMove( (k*10*Fs)+1 : ((k+1)*10*Fs) ) ; % 5�ʾ� �������
    end
    
     L = length(ResMove5s);
     t = (0:L-1)*T;

     % ȣ������ ����, FFT
    ymr = filtfilt(Res_filter,ResMove5s);
    S2 = fft(ymr);
    P21 = abs(S2/L);
    P12 = P21(1:L/2+1);
    P12(2:end-1) = 2*P12(2:end-1);
    f = Fs*(0:(L/2))/L;
    
    % frequency domain���� �ִ밪 ���� ���ļ� ����
    [pL1, fL1] = max(P12(2:200));
    f11 = fL1*Fs/L;
    f11
    ResL = 60/(1/(f11)) % 1�д� ȣ��� ���
    
    %�ɹ����� ����, FFT
    ymh = filtfilt(HR_filter,ResMove5s);
    S3 = fft(ymh);
    P23 = abs(S3/L);
    P13 = P23(1:L/2+1);
    P13(2:end-1) = 2*P13(2:end-1);
    f = Fs*(0:(L/2))/L;
   
    % frequency domain���� �ִ밪 ���� ���ļ� ����
    [pL2, fL2] = max(P13(2:200));
    f12 = fL2*Fs/L;
    HR_L = 60/(1/(f12)) % 1�д� �ɹڼ� ���

end
