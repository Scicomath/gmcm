import graph;
size(8cm,5cm,IgnoreAspect);

axes("$s$", "$v$",Arrow,max=(27,90));

real[] limit = {50,60,70,65,50};
real[] length = {3,5,6,6.5,4};
real[] a = {0,0}, b = {0,0};
real middle;
int i;
for (i = 0; i < 5; ++i) {
	a[0] = b[0];
	b[0] = b[0] + length[i];
	a[1] = limit[i];
	b[1] = limit[i];
	draw((a[0],a[1])--(b[0],b[1]),red);
	draw((b[0],-8)--(b[0],90),dashed);
	middle = (a[0] + b[0]) / 2;
	label(string(i+1),(middle,10));
}