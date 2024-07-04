h = 279/576;
z = 1-h;
i = z/3;
x = linspace(0,5,5);
y1 = z*[0,i,i,i,h];
plot(x,y1,'Color','r','LineWidth',2)
xlabel('JOINTS')
ylabel('PDF')
title('Colored Line Graph')