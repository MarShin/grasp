import processing.video.*;
import com.hamoid.*;
import ddf.minim.*;
import processing.serial.*;

//video 
Capture cam;
VideoExport videoExport;

//audio
Minim minim;
AudioInput in;
AudioRecorder recorder;

Serial mySerial;
char inByte;
boolean recording = false;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(30);
  mySerial=new Serial(this, "COM8", 9600);
  println("Press R to toggle recording");
  videoExport = new VideoExport(this, "video.mp4");
  videoExport.setFrameRate(15);
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i+" "+cameras[i]);
    }

    println("the current camera "+cameras[15]);
    cam = new Capture(this, cameras[15]);
    cam.start();
  }  

  // audio
  minim = new Minim(this);
  in = minim.getLineIn();
  // create a recorder that will record from the input to the filename specified
  // the file will be located in the sketch's root folder.
  recorder = minim.createRecorder(in, "recording.wav");  
  textFont(createFont("Arial", 12));  
}

void draw() {
  if (cam.available() == true && recording) {
    cam.read();
    videoExport.saveFrame();
  }
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  //audio
  if ( recorder.isRecording() )
  {
    text("Currently recording...", 5, 15);
  }
  else
  {
    text("Not recording.", 5, 15);
  }
}

void keyPressed() {
  if(key == 'r' || key == 'R') {
    //video
    recording = !recording;
    println("Recording is " + (recording ? "ON" : "OFF"));
    
    //audio
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    }
    else 
    {
      recorder.beginRecord();
    }
  }
}


void keyReleased()
{
  if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large, 
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording, 
    // it will not freeze as the data is already in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    cam.stop();
    println("Done saving.");
    combineVidAud();
    println("Done combining");
  }
}

public boolean combineVidAud() {

 String[] exeCmd = new String[]{"ffmpeg", "-i", "myrecording.wav", "-i", "test.mp4" ,"video-final.mp4"};

 ProcessBuilder pb = new ProcessBuilder(exeCmd);
 boolean exeCmdStatus = executeCMD(pb);

 return exeCmdStatus;
} //End combineVidAud Function

private boolean executeCMD(ProcessBuilder pb)
{
 pb.redirectErrorStream(true);
 Process p = null;

 try {
  p = pb.start();

 } catch (Exception ex) {
 ex.printStackTrace();
 System.out.println("oops");
 p.destroy();
 return false;
}
// wait until the process is done
try {
 p.waitFor();
} catch (InterruptedException e) {
e.printStackTrace();
System.out.println("woopsy");
p.destroy();
return false;
}
return true;
 }// End function executeCMD
 // End class WrapperExe
