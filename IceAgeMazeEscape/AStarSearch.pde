// This code is from the A* Exercise solution found on studres here:
// https://studres.cs.st-andrews.ac.uk/CS4303/Lectures/W5/CS4303_2022_Wk5_L3_AI4/Astar_exercise/AStarSoln/AStarSearch.pde

// Author Joseph Manfredi Cameron made some tweaks to the code provided at the link above to tailor A* search to this Ice Age Maze Escape game
// Tweaks made are:
// 1. My custom maze/map is represented as a 2D array of custom cells, rather than ints like in the provided example on studres
// 2. I represent walls as booleans not ints, so the constructor looks for isWall() to construct AStarNodes
// 3. I added some extra if statements in the search iteration function to handle edges of my maps

import java.util.Collections ;

public class AStarSearch {
  // Graph represented as an array. This will make querying adjacent nodes easy.
  private AStarNode[][] graph;
  // The open list, from which we will pluck the next node at each iteration
  private ArrayList<AStarNode> open;
  
  // The constructor takes in the game map and builds the graph
  public AStarSearch(MazeCell[][] map) {
    graph = new AStarNode[map.length][] ;
    for (int row = 0; row < map.length; row++) {
      graph[row] = new AStarNode[map[row].length] ;
      for (int col = 0; col < map[row].length; col++) {
        if (!map[row][col].isWall())
          graph[row][col] = new AStarNode(row, col) ;
        else 
          graph[row][col] = null ;
      }
    }    
  }
  
  // resets ready for a new search. Avoids lots of object reconstruction
  private void reset() {
    for (int row = 0; row < graph.length; row++) {    
      for (int col = 0; col < graph[row].length; col++) {
        if (graph[row][col] != null)
          graph[row][col].reset() ;
      }    
    }
  }  
  
  // Process a node adjacent to the current node
  private void process(AStarNode curr, AStarNode node, int currRow, int currCol, int goalRow, int goalCol, int newCost) {
    // if node is null then there was a wall in the visited direction
    if (node == null) return ;
    // if node is closed nothing to do
    if (node.isClosed()) return ;
    // We've been here before
    if (node.isVisited()) {
      if (node.getCost() > newCost) {
        node.setCost(newCost) ;
        node.setPrevNode(curr) ;
      }
    }
    // This node was unvisited
    else {
      node.setCost(newCost) ;
      node.makeEstimate(goalRow, goalCol) ;
      node.setPrevNode(curr) ;
      node.setVisited() ;
      open.add(node) ;
    }     
  }
  
  // returns true if goal node is the first thing on the open list
  // Otherwise processes adjacent nodes
  private boolean searchIteration(int goalRow, int goalCol) {
    Collections.sort(open) ;
    AStarNode currentNode = open.remove(0) ;
    // if this is the goal node we are done.    
    if (currentNode.hasCoords(goalRow, goalCol))
      return true ;
    // Iterate over reachable nodes.
    int currRow = currentNode.getRow() ;
    int currCol = currentNode.getCol() ;
    int newCost = currentNode.getCost() + 1 ;
    // NOTE: AUTHOR 200036885 ADDED IF STATEMENTS BECAUSE MY MAP INCLUDES EDGES
    // look N
    if (currRow > 0) {
      process(currentNode, graph[currRow-1][currCol], currRow, currCol, goalRow, goalCol, newCost) ;
    }
    // look S
    if (currRow < 47) {
      process(currentNode, graph[currRow+1][currCol], currRow, currCol, goalRow, goalCol, newCost) ;
    }
    // look E
    if (currCol < 26) {
      process(currentNode, graph[currRow][currCol+1], currRow, currCol, goalRow, goalCol, newCost) ;
    }
    // look W
    if (currCol > 0) {
      process(currentNode, graph[currRow][currCol-1], currRow, currCol, goalRow, goalCol, newCost) ;
    }
    // This node now done and can be closed  
    currentNode.close() ; 
    return false ;
  }
  
  // Extract path by tracing the prevNode fields of AStarNode
  private ArrayList<AStarNode> extractPath(int sourceRow, int sourceCol, int goalRow, int goalCol) {
    ArrayList<AStarNode>path = new ArrayList<AStarNode>() ;
    AStarNode currNode = graph[goalRow][goalCol] ;
    do {
      path.add(currNode) ; 
      currNode = currNode.getPrevNode() ;
    } while (currNode != null) ;
    return path ;
  }
  
  // Start the A* search for a path between the specified points
  public ArrayList<AStarNode> search(int sourceRow, int sourceCol, int goalRow, int goalCol) {
    reset() ;
    // initialise the open list
    open = new ArrayList<AStarNode>() ;
    open.add(graph[sourceRow][sourceCol]) ;
    graph[sourceRow][sourceCol].setCost(0) ;
    // Continue until the open list is empty (which may indicate failure), or the goal is the first thing on open
    while(!open.isEmpty()) {
      if (searchIteration(goalRow, goalCol)) {
        return extractPath(sourceRow, sourceCol, goalRow, goalCol) ;
      }
    }
    return null ;
  }  
}
