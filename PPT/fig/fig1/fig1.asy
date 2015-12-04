import graph;
size(5cm,0);

real f(real x) {return 1/(x + 0.2) - 0.2;};

bool3 branch(real x)
{
	static int lastsign=0;
	if(x == 0) return false;
	int sign=sgn(x);
	bool b = lastsign == 0 || sign == lastsign;
	lastsign = sign;
	return b ? true : default;
}

draw(graph(f,0.1,3.5),red);
axes("$t$","$E$",Arrow);

pair P = (2,2);
pair a1 = (0.6,2.9), a2 = (0.2,2.3);
dot(P);
label("$P(t,E)$",P,E);

draw(a1--a2,Arrow);
label("Pareto front",a1,E);