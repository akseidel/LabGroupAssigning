// Display related functions
String windowTitle = "Lab Group Assigning";
void initDisplays() {
  surfaceSetup();
  lastWidth = width;
  lastHeight = height;
  fontSetUp();
  classSizeCheck(textfieldClassSize);
  showInitialHeader(true);
}

void surfaceSetup() {
  surface.setTitle(windowTitle);
  surface.setResizable(true);
}

void fontSetUp() {
  f = createFont("Monospaced", fontsize, true);
  textFont(f);
  textAlign(LEFT);
  fill(0);
}

void showInitialHeader(boolean inConsoleOnly) {
  StringBuilder sbMsg = new StringBuilder();
  sbMsg.append("Class Size: ");
  sbMsg.append(classSize);
  sbMsg.append( "  # Groups: ");
  sbMsg.append(groupQty);
  sbMsg.append("  # Rounds: ");
  sbMsg.append(roundsQty);
  sbMsg.append( "  Group Size: ");
  sbMsg.append( gSize);
  sbMsg.append("  Pool Size ");
  sbMsg.append(nfc(poolSize));
  if (inConsoleOnly) {
    println(sbMsg.toString());
  }
  if (!inConsoleOnly) {
    text(sbMsg.toString(), drawborder, currentlineY);
  }
  sbMsg.setLength(0);
  sbMsg.append("Performing at most ");
  sbMsg.append(nfc(trialQty));
  sbMsg.append( " solution trials ... Press q at any time to terminate.");
  if (inConsoleOnly) {
    println(sbMsg.toString());
  }
  if (!inConsoleOnly) {
    text(sbMsg.toString(), drawborder, nextLineY());
  }
  sbMsg.setLength(0);
  sbMsg.append(timeSolStart);
  sbMsg.append(timeSolEnd);
  if (inConsoleOnly) {
    println(sbMsg.toString());
  }
  if (!inConsoleOnly) {
    text(sbMsg.toString(), drawborder, nextLineY());
  }
  
}

void printFirstBest(boolean stopConsoleOutput) {
  StringBuilder sbMsg = new StringBuilder();
  sbMsg.append("First best number of unfilled groups in ");
  sbMsg.append(nfc(trialQty));
  sbMsg.append(" trials. ");
  sbMsg.append(bestunfilledQty);
  sbMsg.append(" unfilled in trial: ");
  sbMsg.append(nfc(besttrialrun));
  nextLineY();
  text(sbMsg.toString(), drawborder, nextLineY());
  if (! stopConsoleOutput) {
    println(sbMsg.toString());
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
  StringBuilder sbMsg = new StringBuilder();
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gSize*2)+(gSize-1);   // group text length
  int cospc = 4;                  // space between columns

  printMatrixHeader(atScreenOnly);
  sbMsg.append("Group ");
  sbMsg.append(spc(5));
  for (int col = 0; col < groupQty; col ++ ) {
    String strHN = str((col+1));
    sbMsg.append(strHN);
    sbMsg.append(spc(gw+cospc-strHN.length()));
  } 
  sbMsg.append("Chk:");
  if (! atScreenOnly) {
    println(sbMsg.toString());
  }
  text(sbMsg.toString(), drawborder, nextLineY());

  for (int row =0; row < roundsQty; row ++) {
    StringBuilder sbMsg1 = new StringBuilder();
    sbMsg1.append("Round ");
    sbMsg1.append(nf((row+1), 2));
    sbMsg1.append("   ");
    for (int col = 0; col < groupQty; col ++ ) {
      sbMsg1.append(bestlabGroupMatrix[row][col].showMembers());
      sbMsg1.append(spc(cospc));
      checkSumRow = checkSumRow + bestlabGroupMatrix[row][col].sumMembers();
    }
    sbMsg1.append(checkSumRow);
    if (! atScreenOnly) {
      println(sbMsg1.toString());
    }
    text(sbMsg1.toString(), drawborder, nextLineY());
    checkSumRow = 0;
  }
  StringBuilder sbMsg2 = new StringBuilder();
  sbMsg2.append("Chk:");
  sbMsg2.append(spc(7));
  for (int col = 0; col < groupQty; col ++ ) {
    for (int row =0; row < roundsQty; row ++) {
      checkSumCol = checkSumCol + bestlabGroupMatrix[row][col].sumMembers();
    }
    String strCSV = str(checkSumCol);
    sbMsg2.append(strCSV);
    sbMsg2.append(spc(gw+cospc-strCSV.length()));
    checkSumCol = 0;
  }
  if (! atScreenOnly) {
    println(sbMsg2.toString());
  }
  text(sbMsg2.toString(), drawborder, nextLineY());
  nextLineY();
  // output the history list
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
    msg = "Completed in " + nf(duration, 0, 3) + " seconds." ;
  } else if ((duration < 3600) & (duration > 90)) { //msg when under hour but above 90 seconds
    msg = "Completed in " + nf(duration/60, 0, 3) + " minutes.";
  } else { // msg when above an hour
    msg = "Completed in " + nf(duration/3600, 0, 3) + " hours.";
  }
  msg = "Process terminated by keypress after trial " + nfc(run) + " at time " +timeElapsed(milliStart, milliEnd) + ".";
  isMsgFeedBack = true;
  println(msg);
  lastStatusMsg = msg;
  historyList.append("Stopped, trial: " + nfc(run) + " , at " + timeElapsed(milliStart, millis()));
} // end reportQuitNowMessage

// Function to return a string of len spaces.
String spc(int len) {
  StringBuilder s = new StringBuilder();
  while (s.length() < len ) {
    s.append(" ");
  }
  return s.toString();
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
// int whereTo is a switch for where the report goes.
// whereTo 0 = comnsole, whereTo 1 is file
void reportLeftOverGroups(boolean atScreenOnly, int whereTo) {
  PossibleGroupsK freshMstrPosGroups;
  StringBuilder sbRpt = new StringBuilder();
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
  rm = freshMstrPosGroups.pGroups.size();
  printlnWhereTo("", whereTo);  
  printlnWhereTo(rm + " Lab Groups remaining:", whereTo);
  for (LabGroup lg : freshMstrPosGroups.pGroups) {
    if (sbRpt.length() < 120) {
      sbRpt.append(lg.showMembers());
      sbRpt.append(remGpSep);
    } else {
      printlnWhereTo(sbRpt.toString(), whereTo);
      sbRpt.setLength(0);
      sbRpt.append(lg.showMembers());
      sbRpt.append(remGpSep);
    }
  }
  printlnWhereTo(sbRpt.toString(), whereTo);
} //end reportLeftOverGroups

// Directed output according to int whereTo
// 0 => console
// 1 => File
void printlnWhereTo(String msg, int whereTo) {
  switch(whereTo) {
    case(0):
    println(msg);
    break;
    case(1):
    if (theFileOutput != null) {
      theFileOutput.println(msg);
      break;
    }
  }
}



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
