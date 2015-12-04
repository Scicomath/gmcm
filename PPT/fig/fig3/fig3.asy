import graph;
size(5cm,0);

real labelSize = 6;
real f(real x) {return 1/(x + 0.2) - 0.2;};

draw(graph(f,0.1,3.5),red);
axes("$t$","$E$",Arrow);

pair L1 = (0.2,-0.3), L2 = (0.2,3), Tn = (0.2,0);
pair intersectP = (0.2,2.3),intersectP2 = (1.05,0.6);

draw(L1--L2);
dot(intersectP,red);
label("$(t_n,E_{\min})$",intersectP,NE,fontsize(labelSize));
label("$t_n$",Tn,SE);

pair RL1 = (-0.3,0.6), RR1 = (3,0.6);
draw(RL1--RR1,dashed);
dot(intersectP2,red);
label("$(t_0, E_0)$",intersectP2,NE,fontsize(labelSize));

int n = 5;
real deltaY = 2.3 - 0.6, y0 = 0.6;
real x,y;
for (int i=1; i<=n; ++i) {
	y = y0 + i * deltaY / n;
	draw((-0.3,y)--(3,y),dashed);
	x = 1.0 / (y + 0.2) - 0.2;
	dot((x,y),red);
	if (i != 5) {
		label("$(t_" + string(i) + ", E_" + string(i) + ")$",(x,y),NE,fontsize(labelSize));
	}
	
}