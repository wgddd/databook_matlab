clear all; close all; clc

L=30; n=512; x2=linspace(-L/2,L/2,n+1); x=x2(1:n); % spatial discretization
k=(2*pi/L)*[0:n/2-1 -n/2:-1].';                    % wavenumbers for FFT
V=x.^2.';    % potential
t=0:0.2:20;   % time domain collection points

u=exp(-0.2*(x-1).^2);   % initial conditions
ut=fft(u);              % FFT initial data
[t,utsol]=ode45('ch_pod_harm_rhs',t,ut,[],k,V);   % time-stepping of PDE
for j=1:length(t)
  usol(j,:)=ifft(utsol(j,:));                     % transforming back
end

u2=exp(-0.2*(x-0).^2);
ut=fft(u2);
[t,utsol]=ode45('ch_pod_harm_rhs',t,ut,[],k,V);
for j=1:length(t)
  usol2(j,:)=ifft(utsol(j,:));
end

figure(1)
subplot(2,2,2)
surfl(x,t,abs(usol)+2), shading interp, colormap(gray) %colormap([0 0 0])
hold on
pcolor(x,t,abs(usol)), shading interp, %colormap(gray)
view(20,25)
tv=0*x+20;
Vx=x.^2;
plot3(x(12:end-12),tv(12:end-12),Vx(12:end-12)/100+2,'k','Linewidth',[2])
set(gca,'Xlim',[-15 15],'Ylim',[0 20],'Zlim',[0 4],'Xtick',[-15 -10 -5 0 5 10 15],'Ytick',[0 10 20],'Ztick',[2 3 4], ...
    'Zticklabel',{'0','1','2'},'Fontsize',[15]);

figure(1)
subplot(2,2,1)
surfl(x,t,abs(usol2)+2), shading interp, colormap(gray) %colormap([0 0 0])
hold on
pcolor(x,t,abs(usol2)), shading interp, %colormap(gray)
view(20,25)
tv=0*x+20;
Vx=x.^2;
plot3(x(12:end-12),tv(12:end-12),Vx(12:end-12)/100+2,'k','Linewidth',[2])
set(gca,'Xlim',[-15 15],'Ylim',[0 20],'Zlim',[0 4],'Xtick',[-15 -10 -5 0 5 10 15],'Ytick',[0 10 20],'Ztick',[2 3 4], ...
    'Zticklabel',{'0','1','2'},'Fontsize',[15]);


%surfl(x,t,abs(usol)), colormap(gray)

for j=1:length(t)
    usol3(j,:)=usol(j,n:-1:1);
end

usym=[usol; usol3];

[U,S,V]=svd(usol.');
[U2,S2,V2]=svd(usol2.');
[U3,S3,V3]=svd(usym.');


figure(1)
subplot(4,2,6)
plot(100*diag(S)/sum(diag(S)),'ko','Linewidth',[2]), grid on
set(gca,'Xlim',[0 20],'Ylim',[0 80],'Ytick',[0 40 80],'Fontsize',[15])
xlabel('')

subplot(4,2,5)
plot(100*diag(S2)/sum(diag(S2)),'ko','Linewidth',[2]), grid on
set(gca,'Xlim',[0 20],'Ylim',[0 80],'Ytick',[0 40 80],'Fontsize',[15])
xlabel('')


figure(2)
subplot(3,1,3)
sn=[-1 1 1 1 -1];
for j=1:5
  nrm=sqrt(trapz(x,U(:,j).^2));
  Up(:,j)=real(U(:,j))*sn(j)/nrm;
end
plot(x,real(Up(:,1:5)),'Linewidth',[2])
set(gca,'Xlim',[-5 5],'Xtick',[-5 -2.5 0 2.5 5],'Ylim',[-1 1],'Ytick',[-1 -0.5 0 0.5 1],'Fontsize',[15])
legend('mode 1','mode 2','mode 3','mode 4','mode 5')

subplot(3,1,2)
sn=[-1 -1 1 -1 -1];
for j=1:5
  nrm=sqrt(trapz(x,U2(:,j).^2));
  Up2(:,j)=real(U2(:,j))*sn(j)/nrm;
end
plot(x,real(Up2(:,1:5)),'Linewidth',[2])
set(gca,'Xlim',[-5 5],'Xtick',[-5 -2.5 0 2.5 5],'Ylim',[-1 1],'Ytick',[-1 -0.5 0 0.5 1],'Fontsize',[15])
% subplot(4,1,4)
% sn=[-1 1 1 1 -1];
% for j=1:5
%   Up3(:,j)=real(U3(:,j))*sn(j)/norm(U3(:,j));
% end
% plot(x,real(Up3(:,1:5)),'Linewidth',[2])
% set(gca,'Xlim',[-5 5],'Xtick',[-5 -2.5 0 2.5 5],'Ylim',[-0.2 0.2],'Ytick',[-0.2 -0.1 0 0.1 0.2],'Fontsize',[15])




h=[1+0*x; 2*x; 4*x.^2-2; 8*x.^3-12*x; 16*x.^4-48*x.^2+12];
for j=0:4
   phi(:,j+1)=(1/(sqrt(factorial(j)*(2^j)*sqrt(pi))).*exp(-x.^2/2).*h(j+1,:)).';
   nrm=sqrt(trapz(x,phi(:,j+1).^2));
   phi2(:,j+1)=phi(:,j+1)/nrm;
end
subplot(3,1,1), plot(x,phi2,'Linewidth',[2]),
set(gca,'Xlim',[-5 5],'Xtick',[-5 -2.5 0 2.5 5],'Ylim',[-1 1],'Ytick',[-1 -0.5 0 0.5 1],'Fontsize',[15])

