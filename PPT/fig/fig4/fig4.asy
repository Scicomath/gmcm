
import graph;
size(6.5cm,0);

pair s0 = (0,0), s1 = (2.0,5.0), s2 = (6.0,5.0), s3 = (9.5,3.5), s4 = (11,0);
pair c1 = (0.9,3.2), c2 = (7.75,4.5), c3 = (10.25,2.0);
dot(s1);
dot(s2);
dot(s3);
dot(s4);

axes("$s$","$v$", Arrow, min=(-0.6,-0.6),max=(12,7));

draw(s0..controls c1..s1--s2..controls c2..s3..controls c3..s4);

label("Acceleration",c1,SE,fontsize(3));
label("Cruising",(3.9,5),N,fontsize(3));
label("Coasting",c2,NE,fontsize(3));
label("Braking",c3,E,fontsize(3));