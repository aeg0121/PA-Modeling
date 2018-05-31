function plot_results(type, label, data, data2)
%plot_results Plot our various results

switch type
   case 'constellation'
      figure(2); hold on; grid on;
      plot(data, 'x','DisplayName',label);
      title('Constellation')
      legend(gca,'show');
      
   case 'psd'
      figure(100);
      Nfft    = 1024;
      Window  = kaiser(1000,9);
      Signal_PSD = 10*log10(fftshift(pwelch(data,Window)));
      plot((-1:2/Nfft:1-2/Nfft)*((data2)/(2e6)), Signal_PSD, 'LineWidth', 2, 'DisplayName', label);
      xlabel('Frequency (MHz)')
      ylabel('PSD')
      hold on;
      legend(gca,'show');
      grid on;
      
   case 'am/am'
      figure(3); hold on; grid on;
      plot(abs(data),abs(data2),'o','DisplayName',label)
      title('AM AM Curve')
      xlabel('PA Input Magnitude');
      ylabel('PA Output Magnitude');
      legend(gca,'show','Location', 'Best');
      
   case 'symbols'
      figure(1); hold on; grid on;
      plot(abs(data), 'DisplayName',label);
      title('Magnitude of symbols vs Subcarrier Index');
      xlabel('Subcarrier Index');
      legend(gca,'show');
      
   case 'model'
      figure(3); hold on; grid on;
      plot(abs(data2), abs(data), '.', 'DisplayName', label)
      maxabs = max(abs(data2));
      line = linspace(0,maxabs);
      plot(line,line, '--k','DisplayName', 'Ideal linear PA');
      
   case 'pa_out'
      figure(4); hold on; grid on;
      plot(real(data), 'DisplayName', label(1))
      plot(real(data2), 'DisplayName', label(2))
      
   case 'mse'
      bar(label);
      set(gca,'XTickLabel',{'1st Order', '3rd Order', '5th Order', '7th Order', '9th Order'});
      legend('1 Tap', '2 Tap', '3 Tap', '4 Tap');
      xlabel('Maximum Nonlineraity Order of Model')
      ylabel('MSE of PA Model Fit');
      grid on;
end
end

