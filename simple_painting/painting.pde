// The world pixel by pixel 2016
// Daniel Rozin
// paints one pixel on the window under the mouse
PImage slider;
boolean square = false;  
boolean circle = false; 
boolean squiggly = true;
int background = 255; 
int bannerY = 40; 
color theColor; 

void setup() {
  size(1000, 800,P3D);
  background(background);                                     
  slider = loadImage("slider.png");
}

void draw() {  
  ///legend 
  pushMatrix(); 
  fill(0); 
  rect(0,0, width - bannerY, bannerY);
  fill(255);
  text("LEGEND:", 30, 25); 
  text("r : reset", 100, 25); 
  text("q : square", 200, 25); 
  text("w : circle", 300, 25); 
  popMatrix(); 
  
  //image
  image(slider,width-350,2);
  if (mouseY < bannerY){
    colorPicker(); 
  }
  ///guides
  ///square
  if (keyPressed){
      if (key == 'q'){
        square = true; 
        circle = false; 
        squiggly = false; 
      }
  }
  //circle
    if (keyPressed){
      if (key == 'w'){
        circle = true; 
        square = false; 
        squiggly = false; 
      }
  }
  //squiggly
      if (keyPressed){
      if (key == 'e'){
        squiggly = true; 
        circle = false; 
        square = false; 
      }
  }
      if (keyPressed){
      if (key == 'r'){
       background(background);  
      }
  } 
}

void colorPicker() {
  //find the color under the mouse pointer//
  if (mousePressed){
  theColor = get(mouseX, mouseY);
  fill(theColor);
  rect(width - bannerY, 0, bannerY, bannerY); 
  println(theColor);
  return; 
  }
}

void mouseDragged(){  
 if (mouseY > bannerY){ 
 loadPixels();

///circle
if (circle){
  noStroke(); 
  fill(theColor); 
  int CircRadius = 20; 
  ellipse(mouseX, mouseY, CircRadius, CircRadius);
}

//square
if (square){
  int radius = 20;
   for (int w = 0; w < radius; w++){ 
    for (int a = 0; a < radius; a++){
      float pixelUnderMouse = (mouseX-a+mouseY*width) - width * w;  
      //println(int(pixelUnderMouse1));
      constrain(pixelUnderMouse, 0, (pixelWidth*pixelHeight)); 
      pixels[abs(int(pixelUnderMouse))]= color(theColor);  
 }
}
}

//squiggly
if (squiggly){
  int radius = 50;
   for (int w = 0; w < radius; w++){ 
    for (int a = 0; a < radius; a++){
      float pixelUnderMouse1 = (mouseX-a+mouseY*width) - width * w;  
      //println(int(pixelUnderMouse1));
      constrain(pixelUnderMouse1, 0, (pixelWidth*pixelHeight)); 
      pixels[abs(int(pixelUnderMouse1))]= color(theColor);  
 }
}
}
 updatePixels(); 
 }
}