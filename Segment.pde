//segment object that draws line and holds other information
class Segment { 
  float px, py, px2, py2; //begin and end points for line
  float mx1, my1, mx2, my2; //position relative to mouse
  float dx, dy; //x and y directions of line
  float T;  //length of line
  color c; 
  int shapeId; 
  int segId;  
  String segName = "emptySeg";
  float startPos = 0; 
  float endPos = 0; 
  float minHitAbs = 0.5; 
  float maxHitAbs = 0.5; 
  float minHit = 0.5; 
  float maxHit = 0.5; 
  float wfsDistance = 100;
  boolean isHit = false; 
  

  Segment(float _px, float _py, float _px2, float _py2, int _shapeId, int _segId, float _startPos, float _endPos) {
    px = _px; 
    py = _py; 
    px2 = _px2; 
    py2 = _py2; 
    mx1 = ((px - mouseX)/width)*wfsDistance;
    my1 = ((mouseY - py)/width)*wfsDistance;
    mx2 = ((px2 - mouseX)/width)*wfsDistance;
    my2 = ((mouseY - py2)/width)*wfsDistance;    
    dx = px2 - px; 
    dy = py2 - py; 
    T = sqrt(sq(px2-px)+sq(py2-py)); 
    c = color(100,100,120);
    shapeId = _shapeId; 
    segId = _segId; 
    segName = "b" + shapeId + "n" + segId; 
    startPos = _startPos; 
    endPos = _endPos; 
    minHitAbs = (startPos + endPos)/2; 
    maxHitAbs = (startPos + endPos)/2; 
    wfs_addSegment(); 
  }

  Segment(float _px, float _py, float _px2, float _py2, color _c, int _shapeId, int _segId, float _startPos, float _endPos) {
    px = _px; 
    py = _py; 
    px2 = _px2; 
    py2 = _py2; 
    dx = px2 - px; 
    dy = py2 - py; 
    T = sqrt(sq(px2-px)+sq(py2-py)); 
    c = _c;
    shapeId = _shapeId;
    segId= _segId;
    segName = "b" + shapeId + "n" + segId; 
    startPos = _startPos; 
    endPos = _endPos; 
    wfs_addSegment();
  }
  
  void sendHit(float hitPos){
    isHit = true; 
   if(hitPos < minHit ){
    minHit = hitPos;
    minHit = map(minHit,0,1,0,1);  
    minHitAbs = hitPos; 
   }
   if(hitPos > maxHit ){
    maxHit = hitPos; 
    maxHit = map(maxHit,0,1,0,1);
    maxHitAbs = hitPos; 
   }
  }
  void resetHitPoint(){
   minHit = 100; 
   maxHit = -100;  
   isHit = false; 
  }
  void drawObjectRed(){
    stroke(255,0,0); 
    strokeWeight(2); 
    line(px, py, px2, py2);
  }
  void mouseMoved(float _x, float _y){
    mx1 = ((px - _x)/width)*wfsDistance;
    my1 = ((_y - py)/width)*wfsDistance;
    mx2 = ((px2 - _x)/width)*wfsDistance;
    my2 = ((_y - py2)/width)*wfsDistance; 
  }
  
  void drawObject() {
    stroke(c); 
    strokeWeight(6); 
    if(draw_ShapeId){
     fill(0);
     text(shapeId, (px+px2)/2, (py+py2)/2); 
     text(int(startPos*100), px,py); 
     fill(150);
     //if(!isHit)text("no", lerp(px, px2, 0.5), lerp(py, py2, 0.5)); 
     if(isHit){
     text(minHit, lerp(px,px2,minHit),lerp(py,py2,minHit)); 
     text(maxHit, lerp(px,px2,maxHit),lerp(py,py2,maxHit)); 
     }
    }
    if(draw_shapeHit && isHit){
      stroke(c); 
      line(lerp(px,px2,minHit),lerp(py,py2,minHit),lerp(px,px2,maxHit),lerp(py,py2,maxHit)); 
    }
  }
  
  void wfs_addSegment(){ //send newly created segment to the Wave Field Synthesis system for audio representation
   String cmd = "/" + "addsegment";    //x1, y1, x2, y2, r1, r2 (full range)   
    println("added seg: " + segName); 
    OscMessage myOscMessage = new OscMessage(cmd);
    myOscMessage.add(segName);
    myOscMessage.add(shapeId);
    myOscMessage.add(mx1);
    myOscMessage.add(my1); 
    myOscMessage.add(mx2); 
    myOscMessage.add(my2);
    myOscMessage.add(startPos);
    myOscMessage.add(endPos);
    if(isHit){myOscMessage.add(1);
    } else{myOscMessage.add(0);
    }
    oscP5.send(myOscMessage, myBroadcastLocation); 
    
  }
  
  void wfs_setSegment(){ //update segments on the wfs side 
   String cmd = "/" + "setsegment";    //x1, y1, x2, y2, r1, r2 (full range)   
    OscMessage myOscMessage = new OscMessage(cmd);
    myOscMessage.add(segName);
    myOscMessage.add(mx1);
    myOscMessage.add(my1); 
    myOscMessage.add(mx2); 
    myOscMessage.add(my2);
    myOscMessage.add(minHitAbs);
    myOscMessage.add(maxHitAbs);
    if(isHit){myOscMessage.add(1);
    } else{myOscMessage.add(0);
    }
    oscP5.send(myOscMessage, myBroadcastLocation);  

  }
  
  void wfs_removeSegment(){ //remove segment from the wfs side
   String cmd = "/" + "removesegment";    //x1, y1, x2, y2, r1, r2 (full range)   
    OscMessage myOscMessage = new OscMessage(cmd);
    myOscMessage.add(segName);
    oscP5.send(myOscMessage, myBroadcastLocation);  
  }
}

