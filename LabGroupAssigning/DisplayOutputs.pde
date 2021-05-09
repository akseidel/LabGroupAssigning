
void fontSetUp() {
  f = createFont("Monospaced", fontsize, true);
  textFont(f);
  textAlign(LEFT);
  fill(0);
}

void initGUI() {
  textfieldGSize.setText(str(gsize));
  textfieldClassSize.setText(str(classSize));
  textfieldRoundsQTY.setText(str(roundsQty));
  textfieldGroupQty.setText(str(groupQty));
}
void showInitialHeader(boolean inConsoleOnly) {
  msg = "Class Size: " + classSize + "  # Groups: " + groupQty + "  # Rounds: " + roundsQty + "  Group Size: " + gsize;
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
    text(msg, drawborder, nextlineY());
  }
}

void printFirstBest(boolean stopConsoleOutput) {
  msg ="First best number of unfilled groups in "+ trialQty+ " runs. "+ bestunfilledQty+ " unfilled in Run #:"+ besttrialrun ;
  nextlineY();
  text(msg, drawborder, nextlineY());
  if (! stopConsoleOutput){
    println(msg);
  }
} 

void printMatrixHeader(boolean atScreenOnly) {
  msg ="Lab Groups Matrix - Student may occur only once in any row and once in any column.";
  if (! atScreenOnly) {
    println();
    println(msg);
  }
  nextlineY();
  text(msg, drawborder, nextlineY());
  msg ="Student Class Size: " + classSize;
  if (! atScreenOnly) {
    println(msg);
  }
  text(msg, drawborder, nextlineY());
}// end printMatrixHeader

void printBestResultsMatrix(boolean atScreenOnly) {
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gsize*2)+(gsize-1);   // group text length
  int cospc = 4;                  // space between columns
  msg = "Group " + spc(5);
  for (int col = 0; col < groupQty; col ++ ) {
    String strHN = str((col+1));
    msg = msg +  strHN  + spc(gw+cospc-strHN.length())  ;
  } 
  msg = msg + "Chk:"   ;
  if (! atScreenOnly) {
    println(msg);
  }
  text(msg, drawborder, nextlineY());
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
    text(msg, drawborder, nextlineY());
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
  text(msg, drawborder, nextlineY());
}// end printBestResultsMatrix

int nextlineY() {
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
