import processing.serial.*;
import processing.video.*;


Serial mySerial;
char inByte;
Movie mov;
boolean playToStop=false;
PImage blkImg;
String[] videoList;

//test
Movie[] movArray;
int index;

void setup() {

  size(displayWidth, displayHeight);
  frameRate(30);
  mySerial=new Serial(this, "COM3", 9600);

  blkImg=loadImage("photo/black.png");
  image (blkImg, 0, 0, width, height);
  println("width and height: "+width+" "+height);
  
  // load videos in folder
  index=0;
  String[] videoListTemp=getListOfItemsInFolder("/video");
  movArray = new Movie[videoListTemp.length];
  for(int i=0;i<videoListTemp.length;i++){
    movArray[i] = new Movie(this,"video/"+videoListTemp[i]);
  }
   
}

void draw() {

  while (mySerial.available () > 0) {
    inByte = mySerial.readChar();
    println(inByte);
    if (inByte=='0') {
      image (blkImg, 0, 0, width, height);
      if (playToStop) {
        movArray[index].stop();
        playToStop=false;
      }
      
      // randomize video to play
      index = int(random(movArray.length));
      println("index="+index);      
    }
    if (inByte=='1') {
      println("play");
      playOneFrame();
      playToStop=true;
    }
  }
}

void playOneFrame() {  
  println(index);
  movArray[index].play(); 
  image (movArray[index], 0, 0, width, height);
}

/*
void loadVideo() {
  videoList=getListOfItemsInFolder("/video");
  int index = int(random(videoList.length));
  println("video: "+ videoList[index]);
  mov = new Movie(this, "video/"+videoList[index]);
}
*/

void movieEvent(Movie m) {
  println("movie Event");
  m.read();
}

String[] getListOfItemsInFolder(String path) {
  File dir = new File(dataPath(path));
  String[] list = dir.list();

  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
    println(path);
  } else {
    println(list);
  }
  return list;
}

