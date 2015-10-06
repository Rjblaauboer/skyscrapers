//ray that will do raytracing
class Ray {
  float px, py, px2, py2; //px, py is origin, px2, py2 is direction of raytracing, since a ray is infinitely long
  float dx, dy, angle, angleDegrees; //calculated dx and dy components
  float dx_norm, dy_norm; //normalized dx and dy
  float hitX, hitY, temp_hitX, temp_hitY;  
  boolean segmentHit = false;  
  boolean firstHit = true; 
  float Tlen = 0; 
  float iniT = width*5; 
  boolean definedByAngle = false; 
  int shapeId = 0; 
  float hitPoint = 0; 
  float relHitPoint = 0; 
  float tempRelHitPoint = 0; 
  float tempHitPoint = 0; 
  Segment segHit; 

  Ray(float _px, float _py, float _px2, float _py2) {
    px = _px; 
    py = _py; 
    px2 = _px2; 
    py2 = _py2; 
    dx = px2 - px; 
    dy = py2 - py; 
    dx_norm = (1/(abs(dx)+abs(dy)))*(dx);//divide one by delta x and y and   
    dy_norm = (1/(abs(dx)+abs(dy)))*(dy);//multiply by x to get normalized dy (or dy)
    angle = atan2(dy, dx);
  }  
  
  Ray(float _px, float _py, float _angle) { //set angle and color
    definedByAngle = true; 
    px = _px; 
    py = _py;
    angle = _angle; 
    dx = cos(angle)*iniT;
    dy = sin(angle)*iniT; 
    dx_norm = (1/(abs(dx)+abs(dy)))*(dx);//divide one by delta x and y and   
    dy_norm = (1/(abs(dx)+abs(dy)))*(dy);//multiply by x to get normalized dy (or dy)
  }       


  void setOrigin(float x, float y) {
    px = x; 
    py = y;
  }

  void setAim(float x, float y) {
    px2 = x; 
    py2 = y;
  }

  void update() {
    if (definedByAngle) {
      dx = cos(angle);
      dy = sin(angle);
    } else {
      dx = px2 - px; 
      dy = py2 - py; 
      angle = atan2(dy, dx);
    }
    dx_norm = (1/(abs(dx)+abs(dy)))*(dx);//divide one by delta x and y and   
    dy_norm = (1/(abs(dx)+abs(dy)))*(dy);//multiply by x to get normalized dy (or dy)
    angleDegrees = angle*(180/PI);
  }

  void setHit(float x, float y) {
    hitX = x; 
    hitY = y;
  }

  void setAngle(float _angle) {
    angle = _angle; 
    dx = cos(angle);
    dy = sin(angle);
  }

  void rayTrace() {
    segmentHit = false; 
    Tlen = 0; 
    Segment closestSeg = segments.get(0); 
    for (int i = 0; i<segments.size (); i++) {
      Segment seg = segments.get(i); 
      float s_px = seg.px; 
      float s_py = seg.py; 
      float s_dx = seg.dx; 
      float s_dy = seg.dy; 
      float T1, T2; 
      //check if directions are the same 
      if (abs(dx/dy) == abs(s_dx/s_dy)) {
        //do nothing
      } else {//continue calculation
        T2 = (dx*(s_py-py) + dy*(px-s_px))/(s_dx*dy - s_dy*dx);
        T1 = (s_px+s_dx*T2-px)/dx;
        if (T1 < 0) {//if the intersection is not outside the length of the segment
        } //do nothing
        else if (T2<0 || T2>1) {
        } //do nothing
        else { //if they fall within these criteria, continue
          if (firstHit || T1 < Tlen ) {//firsthit or this intersection is closer
            firstHit = false; 
            tempHitPoint = map(T2, 0, 1, seg.startPos, seg.endPos); 
            tempRelHitPoint = T2; 
            Tlen = T1; 
            temp_hitX = px + dx*T1; 
            temp_hitY = py + dy*T1;
            shapeId = seg.shapeId;
            closestSeg = seg;
          }
        }
      }
    }
    if (!firstHit) { //if there has been a hit at all, firstHit has been set to false
      hitX = temp_hitX; 
      hitY = temp_hitY; 
      segmentHit = true; 
      firstHit = true;
      if(definedByAngle){
      hitPoint = tempHitPoint;
      relHitPoint = tempRelHitPoint; 
      closestSeg.sendHit(relHitPoint);  
      }
      segHit = closestSeg; 
    }
  }


  void dumpInfo() {
    if (definedByAngle) {
      print("sideRay - ");
    } else {
      print("Ray - ");
    }
    print("px = " + px + ", ");  
    print("py = " + py + ", "); 
    print("angle = " + angle + ", "); 
    print("segmentHit = " + segmentHit + ", ");
    print("definedByAngle = " + definedByAngle + ", "); 
    println("");
  }
}

