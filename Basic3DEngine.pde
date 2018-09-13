//float[][] coordinates = {{0, 0, 500}, {0, 0, -500}, {0, 500, 0}, {0, -500, 0}, {500, 0, 1}, {-500, 0, 0}};
float[][] coordinates = {{100, 100, 100}, {100, -100, 100}, {-100, -100, 100}, {-100, 100, 100}, {100, 100, -100}, {100, -100, -100}, {-100, -100, -100}, {-100, 100, -100}};
int[][] edges = {{0, 1}, {1, 2}, {2, 3}, {3, 0}, {0, 4}, {1, 5}, {2, 6}, {3, 7}, {4, 5}, {5, 6}, {6, 7}, {7, 4}};
//int[][] edges = {{4, 5}, {5, 6}, {6, 7}, {7, 4}};
//int[][] edges = {{0, 4}, {1, 5}, {2, 6}, {3, 7}};
//int[][] edges = {{0, 1}, {1, 2}, {2, 3}, {3, 1}};
int w = 800;
int h = 800;
float xOffset = w/2;
float yOffset = h/2;
float cameraX = -1000;
float cameraY = 0;
float cameraZ = 0;
float cameraXDelta = cameraX;
float cameraYDelta = 0;
float cameraZDelta = 0;
float oldMouseX = mouseX;
float oldMouseY = mouseY;




void setup(){
  size(800, 800);
  //double[][] coordinates = {{0, 0, 500}, {0, 0, -500}, {0, 500, 0}, {0, -500, 0}, {500, 0, 1}, {-500, 0, 0}};
  //int[][] edges = {{0, 1}, {2, 3}, {4, 5}};
  //coordinates = rotateAroundX(0.1, coordinates);
  
} 
 
void draw()
{
  background(255);
  coordinates = translate(coordinates);
  //coordinates = rotateAroundX(0.005, coordinates);
  coordinates = rotateAroundY(getYRotation(), coordinates);
  coordinates = rotateAroundZ(getZRotation(), coordinates);
  float[][] parallax = parallax(coordinates);
  float[][] projection = projectToYZ(parallax);
  for(int i = 0; i < edges.length; i++){
    if(coordinates[edges[i][0]][0] > 0 && coordinates[edges[i][1]][0] > 0){
      stroke(0);
      float x1 = projection[edges[i][0]][0];
      float y1 = projection[edges[i][0]][1];
      float x2 = projection[edges[i][1]][0];
      float y2 = projection[edges[i][1]][1];
      line(x1 + xOffset, y1 + yOffset, x2 + xOffset, y2 + yOffset);
    } else {
      //stroke(255, 0, 0, 255);
      //float x1 = projection[edges[i][0]][0];
      //float y1 = projection[edges[i][0]][1];
      //float x2 = projection[edges[i][1]][0];
      //float y2 = projection[edges[i][1]][1];
      //line(x1 + xOffset, y1 + yOffset, x2 + xOffset, y2 + yOffset);
    }
  }
  fill(0);
}

float getZRotation(){
  float theta = (oldMouseX - mouseX)/100;
  oldMouseX = mouseX;
  return theta;
}

float getYRotation(){
  float theta = (mouseY - oldMouseY)/100;
  oldMouseY = mouseY;
  return theta;
}

float[][] translate(float[][] mat){
  float[][] translatedMat = new float[mat.length][mat[0].length];
  for(int i = 0; i < mat.length; i++){
    translatedMat[i][0] = mat[i][0] - cameraXDelta;
    translatedMat[i][1] = mat[i][1] - cameraYDelta;
    translatedMat[i][2] = mat[i][2] - cameraZDelta;
  }
  //print("x shift: ", cameraXDelta, " y shift: ", cameraYDelta);
  cameraXDelta = 0;
  cameraYDelta = 0;
  cameraZDelta = 0;
  return translatedMat;
}

//Filter elements that are behind the camera
//float[][] filter(float[][] mat){
//  int filterLength = 0;
//  for(int i = 0; i < edges.length; i++){
//    float[] p1 = mat[edges[i][0]];
//    float[] p2 = mat[edges[i][1]];
//    if(p1[0] > 0 && p2[0] > 0){
//      filterLength++;
//    }
//  }
//}
  
//  float[][] filteredMat = new float[filterLength][3];
//  int filterIndex = 0;
//  for(int i = 0; i < edges.length; i++){
//    float[] p1 = mat[edges[i][0]];
//    float[] p2 = mat[edges[i][1]];
//    if(p1[0] > 0 && p2[0] > 0){
//      filteredMat[filterIndex] = 
//    }
//  }
//}

float[][] parallax(float[][] mat){
  float[][] translatedMat = new float[mat.length][mat[0].length];
  for(int i = 0; i < mat.length; i++){
    float distance = distanceToYZ(mat[i]);
    float moveFactor = 1/(1 + distance/1000);
    //x
    translatedMat[i][0] = mat[i][0];
    //y
    translatedMat[i][1] = mat[i][1] * moveFactor;
    //z
    translatedMat[i][2] = mat[i][2] * moveFactor;
  }
  //print("x shift: ", cameraXDelta, " y shift: ", cameraYDelta);
  //cameraXDelta = 0;
  //cameraYDelta = 0;
  return translatedMat;
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      print(" UP ");
      cameraXDelta = 50;
      cameraX += cameraXDelta;
    } else if (keyCode == DOWN) {
      print(" DOWN ");
      cameraXDelta = -50;
      cameraX += cameraXDelta;
    } else if (keyCode == RIGHT) {
      print(" RIGHT ");
      cameraYDelta = 50;
      cameraY += cameraYDelta;
    } else if (keyCode == LEFT) {
      print(" LEFT ");
      cameraYDelta = -50;
      cameraY += cameraYDelta;
    } else if (keyCode == 'K') {
      print(" RIGHT ");
      cameraZDelta = 50;
      cameraZ += cameraXDelta;
    } else if (keyCode == 'D') {
      print(" LEFT ");
      cameraZDelta = -50;
      cameraZ += cameraXDelta;
    }
  }
  print("cameraX: ", cameraX);
  print("cameraY: ", cameraY);
  print("cameraZ: ", cameraZ);
}

float[][] rotateAroundX(float angle, float[][] matrix){
  float[][] Px = {{1, 0, 0}, {0, cos(angle), sin(angle)}, {0, (-1) * sin(angle), cos(angle)}};
  return matrixMultiply(Px, matrix);
}

float[][] rotateAroundY(float angle, float[][] matrix){
  float[][] Px = {{cos(angle), 0, (-1) * sin(angle)}, {0, 1, 0}, {sin(angle), 0, cos(angle)}};
  return matrixMultiply(Px, matrix);
}

float[][] rotateAroundZ(float angle, float[][] matrix){
  float[][] Px = {{cos(angle), sin(angle), 0}, {(-1) * sin(angle), cos(angle), 0}, {0, 0, 1}};
  return matrixMultiply(Px, matrix);
}
  

float[][] projectToYZ(float[][] coords){
  float[][] projection = new float[coords.length][2];
  for(int i = 0; i < projection.length; i++){
    projection[i][0] = coords[i][1];
    projection[i][1] = coords[i][2];
  }
  return projection;
}

float distanceToCamera(float[] coord){
  float x = pow((cameraX - coord[0]), 2);
  float y = pow((cameraY - coord[1]), 2);
  float z = pow((cameraZ - coord[2]), 2);
  return sqrt(x + y + z);
}

float distanceToYZ(float[] coord){
  float x = pow((cameraX - coord[0]), 2);
  return sqrt(x);
}


float[][] matrixMultiply(float[][] a, float[][] b){
  //a is m x n and b is n x q result is m x q
  a = transpose(a);
  b = transpose(b);
  int m = a.length;
  int q = b[0].length;
  int aCol = a[0].length;
  float[][] result = new float[m][q];
  //
  for(int i = 0; i < m; i++){
    for(int j = 0; j < q; j++){
      for(int k = 0; k < aCol; k++){
        result[i][j] += a[i][k] * b[k][j];
      }
    }
  }
  return transpose(result);
}

float[][] transpose(float[][] mat){
  float[][] transpose = new float[mat[0].length][mat.length];
  for(int i = 0; i < transpose.length; i++){
    for(int j = 0; j < transpose[0].length; j++){
      transpose[i][j] = mat[j][i];
    }
  }
  return transpose;
}