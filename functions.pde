void initializeShapes() { //here the shapes are defined that are to be raytraced - bounding box for the entire frame is needed for a clear mask 
  //bounding box
  totalShapes = 0; 
  if (map == 0) { //map 0 - buildings
    addShape(new float[] {
      -1, -1, -1, 1000+1, 1000+1, 1000+1, 1000+1, -1
    }
    );
    //figure 1
    addShape(new float[] {
      40, 140, 40, 240, 240, 440, 300, 440, 300, 140
    }
    );
    //figure 2
    addShape(new float[] {
      380, 140, 480, 550, 520, 550, 620, 140
    }
    );
    //figure 3
    addShape(new float[] {
      710, 140, 710, 240, 800, 240, 800, 260, 900, 260, 900, 140
    }
    );  
    //figure 4
    addShape(new float[] {
      710, 320, 710, 440, 810, 440, 810, 320
    }
    );
    //figure 5
    addShape(new float[] {
      550, 660, 550, 860, 650, 860, 650, 820, 850, 820, 850, 620, 760, 620, 760, 660
    }
    );  
    //figure 6
    addShape(new float[] {
      40, 560, 40, 880, 320, 880, 320, 840, 300, 840, 300, 680, 320, 680, 320, 660, 160, 560
    }
    );
  } else if (map == 1) { //map 1 - details of object
    addLineShape(new float[] {
      100, 100, 80, 130, 70, 250, 80, 370, 100, 400, 130, 400, 130, 250, 220, 250, 220, 270, 240, 300, 260, 300, 280, 270, 280, 250, 370, 250, 370, 400, 400, 400, 410, 370, 420, 250, 410, 130, 400, 100
    }
    );
  } else if (map == 2) { //map for testing -- wfs max = 16 points
    //figure 1
    addShape(new float[] {
      200, 200, 400, 200, 400, 400, 200, 400,200,350,300,350,300,250,200,250
    }
    );
    //figure 2
    addShape(new float[] {
      480,480,580,480,580,580,480,580
    }
    );
    //figure 4
    addShape(new float[] {
      650, 650, 850, 650, 850, 700, 750, 700, 750, 800, 850, 800, 850, 850, 650, 850
    }
    );
     } else if (map == 3) { //map for testing -- wfs max = 16 points
    //figure 1
    addShape(new float[] {
      380, 140, 480, 550, 520, 550, 620, 140
    }
    );
    //figure 2
    addShape(new float[] {
      280,380, 340,380, 340,750,200,750,200,700,280,700
    }
    );
    //figure 4
    addShape(new float[] {
      550,650,800,500,800,800,775,800,775,700,575,700,575,800,550,800
    }
    );
  } else if (map == 4) { //map for testing -- wfs max = 16 points
    //figure 1
    addShape(new float[] {
      400,400,400,600,600,600,600,400
    }
    );
  } else if (map == 5) { //single line map, also testing
    addLineShape(new float[] {
      180, 250, 320, 250
    }
    );
    addLineShape(new float[] {
      100, 200, 200, 100
    }
    );
    addLineShape(new float[] {
      400, 300, 300, 400
    }
    );
  }
}


void addShape(float[] points) { //this function draws the shapes based on coordinate pairs, needs at least two pairs (which is a line)
  float totalPer = 0; 
  float currPer = 0; 
  float startPos = 0; 
  float endPos = 0; 
  for (int i = 0; i<points.length; i = i + 2) {
    points[i] = map(points[i], 0, 1000, 0, width);
    points[i+1] = map(points[i+1], 0, 1000, 0, height);
  }
  if (points.length%2 != 0) { 
    println("Error: Could not add shape, parameters are not a multiple of two");
  } else if (points.length<4) {
    println("Error: Could not add shape, need at least two coordinate pairs");
  } else {
    for (int i = 0; i<points.length; i = i + 2) {
      totalPer += dist(points[i], points[i+1], points[(i+2)%points.length], points[(i+3)%points.length]);
    }
    for (int i = 0; i<points.length; i = i + 2) {
      startPos = map(currPer, 0, totalPer, 0, 1); 
      currPer += dist(points[i], points[i+1], points[(i+2)%points.length], points[(i+3)%points.length]); 
      endPos = map(currPer, 0, totalPer, 0, 1);
      segments.add( new Segment(points[i], points[i+1], points[(i+2)%points.length], points[(i+3)%points.length], totalShapes, i, startPos, endPos));
    }
    totalShapes++;
  }
}


void addLineShape(float[] points) { //this function draws the shapes as individual lines based on coordinate pairs, needs at least two pairs (which is a line)
  for (int i = 0; i<points.length; i = i + 2) {
    points[i] = map(points[i], 0, 1000, 0, width);
    points[i+1] = map(points[i], 0, 1000, 0, height);
  }

  if (points.length%2 != 0) { 
    println("Error: Could not add shape, parameters are not a multiple of two");
  } else if (points.length<4) {
    println("Error: Could not add shape, need at least two coordinate pairs");
  } else {
    for (int i = 0; i<points.length; i = i + 2) {
      segments.add( new Segment(points[i], points[i+1], points[(i+2)%points.length], points[(i+3)%points.length], totalShapes, i, 0, 1));
      totalShapes++;
    }
  }
}


void initializeRays(ArrayList<Segment> _segments, ArrayList<Ray> _mrays, ArrayList<Ray> _srays) {
  for (int i = 0; i<_segments.size (); i++) {
    Segment seg = _segments.get(i); 
    _mrays.add( new Ray(250, 250, seg.px, seg.py));
    //also add two rays to the side of each ray offset by 0.001 radians
    Ray tRay = _mrays.get(i);
    _srays.add( new Ray(tRay.px, tRay.py, tRay.angle+0.1));
    _srays.add( new Ray(tRay.px, tRay.py, tRay.angle-0.1));
  }
}


void updateRays(ArrayList<Ray> mrays, ArrayList<Ray> srays) { //update all rays, supply both arraylists
  for (int i = 0; i < segments.size (); i++) {
    Segment seg = segments.get(i); 
    seg.resetHitPoint();
  }
  for (int i = 0; i < mrays.size (); i++) {
    Ray tRay = mrays.get(i); 
    tRay.setOrigin(origin[0], origin[1]); 
    tRay.update(); 
    tRay.rayTrace();  
    for (int j = 0; j<2; j++) {
      int id = 0;
      Ray sRay;  
      if (j == 0) {
        id = i*2; 
        sRay = srays.get(id);
        sRay.setAngle(tRay.angle+0.001);
      } else {
        id = i*2+1; 
        sRay = srays.get(id);
        sRay.setAngle(tRay.angle-0.001);
      }
      sRay.setOrigin(tRay.px, tRay.py); 
      sRay.update();
      sRay.rayTrace();
    }
  }
}


void drawShapes(ArrayList<Segment> segs) { //draw all segment lines
  for (int i = 0; i<segs.size (); i++) {
    Segment seg = segs.get(i); 
    seg.drawObject();
  }
} 


void sendToWFS() { //update wfs segments
  for (Segment tSeg : segments) {
    tSeg.wfs_setSegment();
  }
}


