//Richard Lapham
//pixel x pixel 2017

int cellSize= 20;// the size of each element
int gap = 10; 

void setup() {
  size(1000, 800,P3D);              // must use P3D for any 3D stuff
}

void draw() {
  //pointLight(100, 102, mouseY, mouseX, mouseY, mouseY);
  lights();                         // we want the 3D to be shaded
  background (255);
  translate (width/4, height/4); 
  for (int x = 0; x < width; x+=cellSize + gap) {
    for (int y = 0; y < height; y+=cellSize + gap) {
      float distanceToMouse= dist(x, y, mouseX, mouseY);     // calculate the distance of the element to the mouse 
      float blue = 100 + (distanceToMouse)/3;
      float red =  (distanceToMouse)/3;
      float green =  50 + (distanceToMouse)/3; 
      //if (blue >= 255
      fill(red, green, blue); 
      stroke( x % 255 , 255 , 255); 
      pushMatrix();                                          // if we dont push and pop the matrix our transformations will accumolate
      translate(x/2, y/2); 
      rotateX(distanceToMouse/150); 
      rotateY(distanceToMouse/150);   
      rotateZ(distanceToMouse/150);
      box(cellSize - (abs(distanceToMouse)), cellSize - (abs(distanceToMouse)/100), cellSize- (abs(distanceToMouse)/10));
      popMatrix();
    }
  }
} 