//float Cx,Cy,Cr;

class Circle{
 Circle(float x, float y, float r){
   Cx=x;
   Cy=y;
   Cr=r;
 }
 
 void drawCircle(){
  noFill();
  stroke(255,255,255,50);
  strokeWeight(8);
  ellipse(Cx,Cy,Cr,Cr);
  
  
  noStroke();
  for(float i=Cr; i>=0; i--){
  fill(130,120,250,25);
  ellipse(Cx, Cy, 1.5*i, 1.5*i);
  fill(180,100,100,10);
  ellipse(Cx,Cy,Cr/1.75,Cr/1.75);
  }
 }
 
 void spread(){
   //if(Cr<150)
   Cr+=5;
 }
 
 float Cr(){
   return Cr;
 }
 
 float Cx(){
  return Cx; 
 }
 
 float Cy(){
  return Cy; 
 }
}
