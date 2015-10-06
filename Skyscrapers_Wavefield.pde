//Application where the listener can move his position and hear buildings appear and dissapear behind eachother. 
//Made after examples of Nothing to Hide developer Nicky Case 
//http://ncase.me/sight-and-light/
//Audio representation takes place on the Wave Field Synthesis system

import java.util.*;
import oscP5.*; 
import netP5.*; 

OscP5 oscP5; 
NetAddress myBroadcastLocation; 

ArrayList<Segment> segments; 
ArrayList<Ray> myRays; 
ArrayList<Ray> sideRays;

//what to draw
boolean draw_Shapes = true; 
boolean draw_shapeHit = true; 
boolean draw_ShapeId = false; 
boolean sendToWFS = true; 
int map = 0; //0 = main map
float totalTime = 0; 
float currentTime; 

float[] origin = {
  250, 250
}; 
int totalShapes; 


void setup() { 
  size(1080, 800); 
  oscP5 = new OscP5(this, 12000);
   myBroadcastLocation = new NetAddress("127.0.0.1", 9000); //local

  segments = new ArrayList<Segment>();
  myRays = new ArrayList<Ray>();
  sideRays = new ArrayList<Ray>(); 

  origin[0] = width*0.5; //initialize listener position before first touch
  origin[1] = height*0.7; 
  initializeShapes(); //add shapes with coordinate pairs
  initializeRays(segments, myRays, sideRays);
}

void draw() {
  background(242,242,255); 
  origin[0] = mouseX;
  origin[1] = mouseY;
  for (Segment tSeg : segments) {
    tSeg.mouseMoved(origin[0], origin[1]);
  } 

  //create arraylist of intersections and sort it
  updateRays(myRays, sideRays); 

  if (draw_Shapes) { //only drawing shapes
    drawShapes(segments);
  }
  
  float currentTime = millis();
  if (currentTime - totalTime > 80) {
    totalTime = currentTime; 
    if (sendToWFS) {
      sendToWFS();
    }
  }
}

void mouseMoved() {
  for (Segment tSeg : segments) {
    tSeg.mouseMoved(mouseX, mouseY);
  }
}

void exit()
{  
  for (Segment tSeg : segments) {
    tSeg.wfs_removeSegment();
  }
  super.exit();
}

