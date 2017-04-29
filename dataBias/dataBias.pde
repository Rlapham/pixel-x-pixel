import processing.video.*;

Flake[] snowFlakes= new Flake[0];
int [] floor = new int[1280];

int[] rHist = new int[256];
int[] gHist = new int[256];
int[] bHist = new int[256];

int rHistMax;
int gHistMax;
int bHistMax;

int scanStartX = 0; 
int scanStartY = 1; 
int scanEndX = 1280; 
int scanEndY = 1; 
Boolean linePlus = true; 
Boolean showBias = false; 

int redSum; 
int greenSum; 
int blueSum; 
int totSum;

int totLostSum; 
int redLostSum; 
int greenLostSum; 
int blueLostSum; 

Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720);
  frameRate(60);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
  for (int i = 0; i < width; i++)
  floor[i]= int(height); ///this array will accumolate the height of snow pile columns, we start at bottom = height
}


void draw() { 
colorMode(RGB); 
if (!showBias) fill(20, 100); 
if (showBias) fill(20, 20); 
noStroke(); 
rect(0, height/1.4, width, height/1.4); 

  if (ourVideo.available()) {
    ourVideo.read();           // get a fresh frame as often as we can
    image(ourVideo, 0, 0, width, height/1.4);
    for (int i = 0; i< 25; i++) {
      int tempTop;
      int randiX= (int)random(0, width);                // randomize an x and y positions
      if (scanEndY - 10 <= 0) tempTop = 0; 
      else {
          tempTop = scanEndY - 10; 
      }
      int tempFloor = scanEndY + 10; 
      int randiY= (int)random(tempTop, tempFloor);    
      PxPGetPixel(randiX, randiY, ourVideo.pixels, width); 
      int r_ = R; 
      int b_ = B; 
      int g_ = G; 
      int a_ = A;  
      if (r_ > b_ && r_ > g_){
        //store brightness
        a_ = r_; 
        
        //add to hist or bars
        if (!showBias) redHist(a_); 
        if (showBias) redBar(); 
        
        //record loss
        greenLostSum += g_; 
        blueLostSum += b_; 
        
        //reset pixel
        r_ = 255; 
        b_ = 0; 
        g_ = 0; 
        
        //update sum
        redSum += 1; 
    } else if (g_ > r_ && g_ > b_){
        //store brightness
        a_ = g_;  
        
         //add to hist or bars
        if (!showBias) greenHist(a_); 
        if (showBias) greenBar(); 
            
        //record loss
        redLostSum += r_; 
        blueLostSum += b_; 
        
        //reset pixel
        r_ = 0; 
        b_ = 0; 
        g_ = 255; 
        
        //update sum
        greenSum += 1; 
    } else if (b_ > r_ && b_ > g_){
        //store brightness
        a_ = b_; 
        
         //add to hist or bars
        if (!showBias) blueHist(a_); 
        if (showBias) blueBar(); 

        //record loss
        redLostSum += r_; 
        greenLostSum += g_; 
        
        //reset pixel
        r_ = 0; 
        b_ = 255; 
        g_ = 0; 
        
        //update sum
        blueSum += 1; 
    }
    //println("cat: " + c_); 
    println("red: " + redSum);
    //println("green: " + greenSum);
    //println("blue: " + blueSum);
    //println("alpha: " + a_); 
    println("redlost: " + redLostSum); 
    //println("greenlost: " + greenLostSum); 
    //println("bluelost: " + blueLostSum); 
    println("totSum: " + totSum); 
    println("totLostSum: " + totLostSum); 
    snowFlakes = (Flake[])append(snowFlakes, new Flake(randiX, randiY, r_, g_, b_, a_)); // create new flake and add to our array
    }
  ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 

  for (int i = 0; i < snowFlakes.length; i++) {
    if (snowFlakes[i].posY < height/1.4){ 
    snowFlakes[i].drawFlake();                             // draw all the flakes we have in our growing array
  }
  }



  updatePixels();
}

//show bias
if (showBias){ 
  println("true");
}


//line scanner
stroke(255); 
strokeWeight(1); 
line(scanStartX, scanStartY, scanEndX, scanEndY); 
if (scanStartY >= height/1.4){
  linePlus = false; 
}
if (scanStartY <= 3){
  linePlus = true; 
}

if (linePlus){
  scanStartY+=3; 
  scanEndY+=3; 
}

if (!linePlus){
  scanStartY-=3; 
  scanEndY-=3; 
}

if (keyPressed){
  if (key == 'z'){
  showBias = true; 
  println("true"); 
}
}

if (keyPressed){
  if (key == 'x'){
  showBias = false;
  println("false"); 
}
}

//total sum 
totSum = redSum + greenSum + blueSum; 
totLostSum = redLostSum + greenLostSum + blueLostSum; 

} // end draw

class Flake {                                            // our flake class that stores a pixel and its colors
  int posX, posY, Red, Green, Blue, Alpha;
  Boolean dead = false;
  Flake(int _posX, int _posY, int _R, int _G, int _B, int _A) {
    posX= _posX;                                        // store the location of the pixel
    posY= _posY;
    Red= _R;                                            // store the colors of the pixel
    Green = _G;
    Blue = _B;
    Alpha = _A;
    //Catagory = _C;
  }
  
  void  drawFlake() {                                 // if your not dead go down
    //ellipse(posX, posY, 5, 5); 
    //if (posY < height/1.4){ 
    //if (!dead) { 
      posY+=10;
    //}
    //}
    
    //}

    //if (posY > height/1.4 - 10 && !dead) {                  // if you reached the floor then die
    //  dead = true;
    //}
    
    //fill(Red, Green, Blue); 
    //noStroke(); 
    //ellipse(posX, posY, 10, 10); 
    //int brush = 10;
    //if (dist(posX, posY, posX+brush, posY+10) < brush){
    //  for (int x = posX - brush; x < posX + brush; x++) {               // lets do the effect for 50 pixels around the mouse
    //  for (int y = posY - brush; y < posY + brush; y++) {
      if (posY > height/1.4 - 30){
       Alpha = 0;  
      }
        PxPSetPixel(posX, posY, Red, Green, Blue, Alpha, pixels, width);     // set the RGB of our to screen
      
      //}
  //} 
}//
}

//red
void redHist(int bri){
    int bright = int(bri);
    rHist[bright]++; 
    
    //max value 
    rHistMax = max(rHist);
    
    //draw histogram
    strokeWeight(0); 
    stroke(255, 0, 0);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < width; i += 3) {
       // Map i (from 0..width) to a location in the histogram (0..255)
      int which = int(map(i, 0, width, 0, 255));
       // Convert the histogram value to a location between the bottom and the top of the picture
      int y = int(map(rHist[which], 0, rHistMax, height, height/1.4));
      line(i, height, i, y);
    }
}

void redBar(){
   int mapSum = int(map(redSum, 0, totSum, 0, 1280));  
   int mapLost = int(map(redLostSum, 0, totLostSum, 0, 1280));  
   int tempHeight = int(height - height/1.4); 
   noStroke(); 
   fill(255, 0, 0); 
   rect(0, height - tempHeight, mapSum, tempHeight/3);
   fill(255, 0, 0, 3); 
   rect(mapSum, height/1.4, mapLost, tempHeight/3);  
}

//green
void greenHist(int bri){
    int bright = int(bri);
    gHist[bright]++; 
    
    //max value 
    gHistMax = max(gHist);
    
    //draw histogram
    strokeWeight(0); 
    stroke(0, 255, 0);
    // Draw half of the histogram (skip every second value)
    for (int i = 1; i < width; i += 3) {
    // Map i (from 0..width) to a location in the histogram (0..255)
      int which = int(map(i, 0, width, 0, 255));
       // Convert the histogram value to a location between the bottom and the top of the picture
      int y = int(map(gHist[which], 0, gHistMax, height, height/1.4));
      line(i, height, i, y);
    }
}

void greenBar(){
   int mapSum = int(map(greenSum, 0, totSum, 0, 1280));  
   int mapLost = int(map(greenLostSum, 0, totLostSum, 0, 1280));  
   int tempHeight = (int(height - height/1.4))/3; 
   noStroke(); 
   fill(0, 255, 0); 
   rect(0, height - (tempHeight*2), mapSum, tempHeight);
   fill(0, 255, 0, 3); 
   rect(mapSum, height - (tempHeight*2), mapLost, tempHeight);  
}

//blue
void blueHist(int bri){
    int bright = int(bri);
    bHist[bright]++; 
    
    //max value 
    bHistMax = max(bHist);
    
    //draw histogram
    strokeWeight(0); 
    stroke(0, 0, 255);
    // Draw half of the histogram (skip every second value)
    for (int i = 2; i < width; i += 3) {
    // Map i (from 0..width) to a location in the histogram (0..255)
      int which = int(map(i, 0, width, 0, 255));
       // Convert the histogram value to a location between the bottom and the top of the picture
      int y = int(map(bHist[which], 0, bHistMax, height, height/1.4));
      line(i, height, i, y);
    }
}

void blueBar(){
   int mapSum = int(map(blueSum, 0, totSum, 0, 1280));  
   int mapLost = int(map(blueLostSum, 0, totLostSum, 0, 1280));  
   int tempHeight = (int(height - height/1.4))/3; 
   noStroke(); 
   fill(0, 0, 255); 
   rect(0, height - (tempHeight), mapSum, tempHeight);
   fill(0, 0, 255, 3); 
   rect(mapSum, height - (tempHeight), mapLost, tempHeight);  
}

// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}