// Display related functions
void initDisplays() {
  surfaceSetup();
  lastWidth = width;
  lastHeight = height;
  fontSetUp();
//  classSizeCheck();
  showInitialHeader(true);
}

void surfaceSetup() {
  surface.setTitle("Lab Group Assiging");
  surface.setResizable(true);
}

void fontSetUp() {
  f = createFont("Monospaced", fontsize, true);
  textFont(f);
  textAlign(LEFT);
  fill(0);
}

void showInitialHeader(boolean inConsoleOnly) {
  msg = "Class Size: " + classSize + "  # Groups: " + groupQty + "  # Rounds: " + roundsQty + "  Group Size: " + gSize + "  Pool Size " + poolSize;
  if (inConsoleOnly) {
    println(msg);
  }
  if (!inConsoleOnly) {
    text(msg, drawborder, currentlineY);
  }
  msg = "Performing at most " + trialQty + " solution trials ... Press q at any time to terminate.";
  if (inConsoleOnly) {
    println(msg);
  }
  if (!inConsoleOnly) {
    text(msg, drawborder, nextLineY());
  }
}

void printFirstBest(boolean stopConsoleOutput) {
  msg ="First best number of unfilled groups in "+ trialQty+ " runs. "+ bestunfilledQty+ " unfilled in Run #:"+ besttrialrun ;
  nextLineY();
  text(msg, drawborder, nextLineY());
  if (! stopConsoleOutput) {
    println(msg);
  }
} 

// Displays header to both screen and console. atScreenONly arg results in display
// to screen only. Console display is supressed.
void printMatrixHeader(boolean atScreenOnly) {
  msg ="Lab Groups Matrix - Student may occur only once in any row and once in any column.";
  if (! atScreenOnly) {
    println();
    println(msg);
  }
  nextLineY();
  text(msg, drawborder, nextLineY());
  msg ="Student Class Size: " + classSize;
  if (! atScreenOnly) {
    println(msg);
  }
  text(msg, drawborder, nextLineY());
}// end printMatrixHeader

void printBestResultsMatrix(boolean atScreenOnly) {
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gSize*2)+(gSize-1);   // group text length
  int cospc = 4;                  // space between columns

  printMatrixHeader(atScreenOnly);
  msg = "Group " + spc(5);
  for (int col = 0; col < groupQty; col ++ ) {
    String strHN = str((col+1));
    msg = msg +  strHN  + spc(gw+cospc-strHN.length())  ;
  } 
  msg = msg + "Chk:"   ;
  if (! atScreenOnly) {
    println(msg);
  }
  text(msg, drawborder, nextLineY());
  for (int row =0; row < roundsQty; row ++) {
    msg = "Round " + nf((row+1), 2) + spc(3);
    for (int col = 0; col < groupQty; col ++ ) {
      msg = msg + bestlabGroupMatrix[row][col].showMembers() + spc(cospc);
      checkSumRow = checkSumRow + bestlabGroupMatrix[row][col].sumMembers();
    }
    msg = msg + checkSumRow;
    if (! atScreenOnly) {
      println(msg);
    }
    text(msg, drawborder, nextLineY());
    checkSumRow = 0;
  }
  msg = "Chk:" + spc(7);
  for (int col = 0; col < groupQty; col ++ ) {
    for (int row =0; row < roundsQty; row ++) {
      checkSumCol = checkSumCol + bestlabGroupMatrix[row][col].sumMembers();
    }
    String strCSV = str(checkSumCol);
    msg = msg + strCSV + spc(gw+cospc-strCSV.length());
    checkSumCol = 0;
  }
  if (! atScreenOnly) {
    println(msg);
  }
  text(msg, drawborder, nextLineY());
}// end printBestResultsMatrix

void outputWarnings() {
  for (String warn : warningsList) {
    text(warn, drawborder, currentlineY);
    nextLineY();
  }
  nextLineY();
}

int nextLineY() {
  currentlineY = currentlineY + fontsize + vfontgap;
  return currentlineY;
}// end nextline

void reportQuitNowMessage(int run) {
  msg = "Process terminated by keypress after run # " + run + "." ;
  isMsgFeedBack = true;
  println(msg);
  lastStatusMsg = msg;
} // end reportQuitNowMessage

// Function to return a string of len spaces.
String spc(int len) {
  String space =" ";
  String s ="";
  while (s.length() < len ) {
    s = s + space;
  }
  return s;
}

void reportResults(int unfilledQty) {
  if (unfilledQty > 0) {
    println();
    println("Number of unfilled groups: ", unfilledQty);
  } else {
    println();
    println("All groups are filled.");
  }
}// end reportResults
