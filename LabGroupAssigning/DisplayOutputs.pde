// Display related functions
void initDisplays() {
  surfaceSetup();
  lastWidth = width;
  lastHeight = height;
  fontSetUp();
  classSizeCheck(textfieldClassSize);
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
  msg = "Class Size: " + classSize + "  # Groups: " + groupQty + "  # Rounds: " + roundsQty + "  Group Size: " + gSize + "  Pool Size " + nfc(poolSize);
  if (inConsoleOnly) {
    println(msg);
  }
  if (!inConsoleOnly) {
    text(msg, drawborder, currentlineY);
  }
  msg = "Performing at most " + nfc(trialQty) + " solution trials ... Press q at any time to terminate.";
  if (inConsoleOnly) {
    println(msg);
  }
  if (!inConsoleOnly) {
    text(msg, drawborder, nextLineY());
  }
}

void printFirstBest(boolean stopConsoleOutput) {
  msg ="First best number of unfilled groups in "+ nfc(trialQty) + " trials. "+ bestunfilledQty + " unfilled in trial: "+ nfc(besttrialrun) ;
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
  nextLineY();
  for (String h : historyList) {
    text(h, drawborder, nextLineY());
  }
}// end printBestResultsMatrix

// Display the warnings
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
  float duration = (float)(milliEnd - milliStart)/1000; // in seconds
  if (duration < 90) { // msg when under 90 second
    msg = "Done in " + nf(duration, 0, 3) + " seconds." ;
  } else if ((duration < 3600) & (duration > 90)) { //msg when under hour but above 90 seconds
    msg = "Done in " + nf(duration/60, 0, 3) + " minutes.";
  } else { // msg when above an hour
    msg = "Done in " + nf(duration/3600, 0, 3) + " hours.";
  }
  msg = "Process terminated by keypress after trial " + nfc(run) + " at time " +timeElapsed(milliStart, milliEnd) + ".";
  isMsgFeedBack = true;
  println(msg);
  lastStatusMsg = msg;
  historyList.append("Stopped, trial: " + nfc(run) + " , at " + timeElapsed(milliStart, millis()));
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

String timeElapsed(int lmStart, int lmEnd) {
  String result;
  float duration = (float)(lmEnd - lmStart)/1000; // in seconds
  if (duration < 90) { // msg when under 90 second
    result = nf(duration, 0, 3) + " seconds" ;
  } else if ((duration < 3600) & (duration > 90)) { //msg when under hour but above 90 seconds
    result = nf(duration/60, 0, 4) + " minutes";
  } else { // msg when above an hour
    result = nf(duration/3600, 0, 5) + " hours";
  }
  return result;
}


// Report the unused LabGroups
void reportLeftOverGroups(boolean atScreenOnly) {
  PossibleGroupsK freshMstrPosGroups;
  String rpt = new String();
  int rm;
  if (atScreenOnly) {
    return;
  }
  freshMstrPosGroups = new PossibleGroupsK(classSize, gSize);
  LabGroup pI;
  for (int pRow = 0; pRow < roundsQty; pRow = pRow+1) {
    for (int pCol = 0; pCol < groupQty; pCol = pCol+1) {
      pI = bestlabGroupMatrix[pRow][pCol];
      // Purge must be performed from end to start
      for (int i = freshMstrPosGroups.pGroups.size()- 1; i >= 0; i--) {
        LabGroup poolLG = freshMstrPosGroups.pGroups.get(i);
        if (poolLG.showMembers().equals(pI.showMembers())) {
          freshMstrPosGroups.pGroups.remove(i);
        }
      }
    }
  } 
  println();
  rm = freshMstrPosGroups.pGroups.size();
  println(rm + " Lab Groups remaining:"); 
  for (LabGroup lg : freshMstrPosGroups.pGroups) {
    if (rpt.length() < 80) {
      rpt = rpt + lg.showMembers() + "  ";
    } else {
      println(rpt);
      rpt = "";
      rpt = rpt + lg.showMembers() + "  ";
    }
  }
  println(rpt);
} //end reportLeftOverGroups

// Retain this. It is used in a beVerbose function that is commented out
void reportResults(int unfilledQty) {
  if (unfilledQty > 0) {
    println();
    println("Number of unfilled groups: ", unfilledQty);
  } else {
    println();
    println("All groups are filled.");
  }
}// end reportResults
