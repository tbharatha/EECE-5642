PImage mapImage;
Table nameTable; 

int currentRow = -1; 
PrintWriter writer; 

void setup() {
  size(650,650);
  mapImage = loadImage("mbta-map.png");
  nameTable = new Table("stations.csv");
  writer = createWriter("locations.csv");
  cursor(CROSS); 
  println("Click the mouse to begin.");
}

void draw() {
  image(mapImage, 0, 0); 
}

void mousePressed() {
  if (currentRow != -1) {
    String abbrev = nameTable.getRowName(currentRow); 
    writer.println(abbrev + "," + mouseX + "," + mouseY);
  }
  
  currentRow++;
  if (currentRow == nameTable.getRowCount()) {
    writer.flush();
    writer.close(); 
    exit(); 
  } else {
    String name = nameTable.getString(currentRow, 1); 
    println("Choose location for " + name + "."); 
  } 
}
