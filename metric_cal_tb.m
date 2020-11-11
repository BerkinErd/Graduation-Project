%% Test bench for Object Detection Algorithm
clear metric_cal;
testFile = 'C:\Users\BERKÝN\Documents\MATLAB\sekil.png';
Image=imread(testFile); %Resmi Okuma


Imagegray=rgb2gray(Image); %Resmi gri seviyeye donusturme


%level=graythresh(Imagegray) %Gri seviye goruntuyu im2bw ile bir ikili goruntuye donusturmek icin kullanýlabilen genel bir esik (seviye) hesaplar.
%BW = im2bw(Imagegray,level);  Resim tamamen siyah-beyaz piksellere donustu.
BW = imbinarize(Imagegray,0.4); %Esige dayali olarak goruntuyu ikili goruntuye donusturme


BW=bwareaopen(BW,30); %Ýkili(binary) resimdeki %30px den daha az piksele sahip nesneleri kaldýrma


Se=strel('disk',10); %Yaricapi 10 olan disk seklinde bir yapilandirma ogesi olusturur.
BW=imclose(BW,Se); %Ikili goruntu BW uzerinde morfolojik kapama gerceklestirir.


BW=imfill(BW,'holes'); %BW'deki delikleri doldurur.


[B,L] = bwboundaries(BW,'noholes'); %Ýkili goruntudeki bolge sinirlarini izleme   *** L nesne disindaki degerleri(arkaplani) ifade eder.
%disp(B);
figure('Name','Bolge Sinirlari','NumberTitle','off'); %Sekil Penceresi Olusturma
imshow(label2rgb(L, @jet, [.5 .5 .5])); %Nesnelerin disindaki alani(arkaplan) reklendirilir. (L) Sinirlari daha iyi ayirt edebilmek icin onemlidir.

hold on
for k = 1:length(B)
  boundary = B{k};      %'k' etiketindeki nesnenin sinir kordinatlarýný (X,Y) belirler
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2) %boundary(:,2) : Y koordinati boundary(:,1) : X koordinati  ***Sirayla butun nesnelerin etrafi 2 pixellik serit ile cevreleniyor.
end

fprintf('Nesneler Isaretlenmistir. Toplam Nesne Sayisi=%d\n',k)

stats = regionprops(L,'Area','Centroid');  % Goruntu bolgelerinin ozelliklerini olcme   *** Area: Alan *** Centroid: Kutle Merkezi
 
% Nesneleri sayan loopun baþlangýcý
for k = 1:length(B)
  
  boundary = B{k}; % 'k' etiketindeki nesnenin sýnýr kordinatlarýný (X,Y) belirler
 
  % Nesnenin çevresini hesaplar
  delta_sq = diff(boundary).^2;
  perimeter = sum(sqrt(sum(delta_sq,2)));

  % 'k' etiketli nesnenin alanýný hesaplar
  area = stats(k).Area;
  
  [metric]=metric_cal(perimeter,area);
 
  % Hesaplanan deðeri gösterir
  metric_string = sprintf('%2.2f',metric);
  centroid = stats(k).Centroid;
  
  %Eðer metric deðer eþik deðerden daha büyük ise yuvarlak nesne kabul edilir.
   if metric > 0.9344
    text(centroid(1),centroid(2),'Cember');
 
  elseif (metric <= 0.8087) && (metric >= 0.7623)
    text(centroid(1),centroid(2),'Dikdortgen');
  elseif (metric <= 0.7393) && (metric >= 0.7380)
    text(centroid(1),centroid(2),'Dikdortgen');
  else
     text(centroid(1),centroid(2),'Belirlenemeyen Sekil');
  end
%disp(metric)
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold');
end