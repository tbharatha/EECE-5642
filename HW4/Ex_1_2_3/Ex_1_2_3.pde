import processing.pdf.*;

// nodes
int nodeCount; 
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

// selection
Node selection;

// record
boolean record; 

// edges
int edgeCount; 
Edge[] edges = new Edge[500];

// font
PFont font; 

void setup() {
  size(650,650);
  font = createFont("SansSerif", 10);
  loadData();
}

void loadData() {
 Table connectionsTable = new Table("connections.csv");
  for(int i=1; i<connectionsTable.getRowCount(); i++)
  {
    String fromPoint = connectionsTable.getString(i,1);    
    String toPoint = connectionsTable.getString(i,2);  
    String lineColor = connectionsTable.getString(i,3); 
    float minutes = connectionsTable.getFloat(i,4);   
    if(i<28){
      lineColor="r";     
    }else if(i<45){
      lineColor="o";
    }else if(i<110){
      lineColor="g";
    }else{
      lineColor="b";
    }
    
    addEdge(fromPoint, toPoint, minutes, lineColor);
  } 
}

void addEdge(String fromLabel, String toLabel, float minutes, String colo) {
  // find nodes
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);
  
  // old edge?
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      return; 
    }
  }
  
  // add edge
  Edge e = new Edge(from, to, minutes,colo);
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e; 
}

Node findNode(String label) {
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n; 
}

Node addNode(String label) {
  Table nodesTable = new Table("locations.csv");
  int nodeIndex = nodesTable.getRowIndex(label);
  float x = nodesTable.getFloat(nodeIndex, 1);
  float y = nodesTable.getFloat(nodeIndex, 2); 
  Node n = new Node(label, x, y, nodeCount);

  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n; 
}

void draw() {
  if (record) {
    beginRecord(PDF, "output.pdf");
  }
  
  textFont(font); 
  smooth();
  
  background(255); 
  
  // draw the edges
  for (int i = 0; i < edgeCount; i++) {
    edges[i].draw();
  }
  
  // draw the nodes
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].draw();
  }
  
  // display station name
  float closest = 5;
  for (int i = 0; i < nodeCount; i++) {
     Node n = nodes[i];
     float d = dist(mouseX, mouseY, n.x, n.y);
     if (d < closest) {
       selection = n;
       closest = d;
     }
  }
   if (selection != null) {
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text(selection.label, 750, 40);
  }
  
  if (record) {
    endRecord();
    record = false;
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    float closest = 5;
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        selection = n;
        closest = d;
      }
    }
  }
}

void mouseDragged() {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
  }
}

void mouseReleased() {
  selection = null;
}

void keyPressed() {
  if (key == 'p') {
    record = true;
  }
}
