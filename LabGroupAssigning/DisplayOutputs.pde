// Display related functions //<>//
String windowTitle = "Lab Group Assigning";


void initDisplays() {
  surfaceSetup();
  lastWidth = width;
  lastHeight = height;
  fontSetUp();
  classSizeCheck(textfieldClassSize);
  showSummaryText(true);
}// end initDisplays

void surfaceSetup() {
  surface.setTitle(windowTitle);
  surface.setResizable(true);
}// end surfaceSetup

void fontSetUp() {
  f = createFont("Monospaced", fontsize, true);
  textFont(f);
  textAlign(LEFT);
  fill(0);
}// end fontSetUp

// show the summary text line
void showSummaryText(boolean inConsoleOnly) {
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
  sbMsg.append(nfc(trialMaxQty));
  sbMsg.append( " solution trials ... Press q at any time to terminate.");
  if (inConsoleOnly) {
    println(sbMsg.toString());
    println();
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
  // session only information
  if (doEstimateProp || doAutoFiling) {
    sbMsg.setLength(0);
    sbMsg.append(timeSStart);
    sbMsg.append(timeSEnd);
    if (inConsoleOnly) {
      println(sbMsg.toString());
    }
    if (!inConsoleOnly) {
      text(sbMsg.toString(), drawborder, nextLineY());
    }
  }
}// end showSummaryText

// reports the first best scoring matrix guess
// atAppWindowOnly arg results in display
// to screen only. Console display is supressed.
void printRptFirstBest(int bestunfilledQty, int besttrialrun, boolean atAppWindowOnly) {
  StringBuilder sbMsg = new StringBuilder();
  sbMsg.append(bestunfilledQty);
  sbMsg.append(" unfilled at trial: ");
  sbMsg.append(nfc(besttrialrun));
  nextLineY();
  text(sbMsg.toString(), drawborder, nextLineY());
  if (! atAppWindowOnly) {
    println(sbMsg.toString());
  }
}// end printRptFirstBest

// Displays header to both screen and console.
// atAppWindowOnly arg results in display
// to screen only. Console display is supressed.
void printMatrixHeader(boolean atAppWindowOnly) {
  msg ="Lab Groups Matrix - Student may occur only once in any row and once in any column.";
  if (! atAppWindowOnly) {
    println();
    println(msg);
  }
  nextLineY();
  text(msg, drawborder, nextLineY());
  msg ="Student Class Size: " + classSize;
  if (! atAppWindowOnly) {
    println(msg);
  }
  text(msg, drawborder, nextLineY());
}// end printMatrixHeader

// Outputs the bestresultsmatrix, which being generated in the
// process thread, can be sometimes entirely null or partially null.
// atAppWindowOnly arg results in display
// to screen only. Console display is supressed.
void printBestResultsMatrix(boolean atAppWindowOnly) {
  StringBuilder sbMsg = new StringBuilder();
  LabGroup matrxPos = defNoSolLG(gSize);
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gSize*2)+(gSize-1);   // group text length
  int cospc = 4;                  // space between columns

  // Sometimes bestlabGroupMatrix is yet to be.
  if (bestlabGroupMatrix == null) {
    return;
  }
  // If processCompleted then best matrix is meaningfull in all conditions.
  // If processWasQuit then best matrix is meaningfull only when not modeRuthless.
  // bestHistList is not meaningfull only when modeRuthless, except for its last
  // line when doEstimateProp, ie estaimating the proportion, is going on.
  if (!modeRuthless || processCompleted) {

    // trial at solution is valid information for completed modeRuthless runs
    if (modeRuthless) {
      printRptFirstBest(bestunfilledQty, besttrialrun, noConsoleOutput);
    }// end if modeRuthless

    // Starting the matrix
    printMatrixHeader(atAppWindowOnly);
    sbMsg.append("Group ");
    sbMsg.append(spc(5));
    for (int col = 0; col < groupQty; col ++ ) {
      String strHN = str((col+1));
      sbMsg.append(strHN);
      sbMsg.append(spc(gw+cospc-strHN.length()));
    }
    sbMsg.append("Chk:");
    if (! atAppWindowOnly) {
      println(sbMsg.toString());
    }
    text(sbMsg.toString(), drawborder, nextLineY());

    // Now Each rounds line
    for (int row =0; row < roundsQty; row ++) {
      StringBuilder sbMsg1 = new StringBuilder();
      sbMsg1.append("Round ");
      sbMsg1.append(nf((row+1), 2));
      sbMsg1.append("   ");
      for (int col = 0; col < groupQty; col ++ ) {
        if (bestlabGroupMatrix[row][col] != null) {
          matrxPos = bestlabGroupMatrix[row][col];
        }
        sbMsg1.append(matrxPos.showMembers());
        sbMsg1.append(spc(cospc));
        checkSumRow = checkSumRow + matrxPos.sumMembers();
      }
      sbMsg1.append(checkSumRow);
      if (! atAppWindowOnly) {
        println(sbMsg1.toString());
      }
      text(sbMsg1.toString(), drawborder, nextLineY());
      checkSumRow = 0;
    }

    // Now the bottom chk row
    StringBuilder sbMsg2 = new StringBuilder();
    sbMsg2.append("Chk:");
    sbMsg2.append(spc(7));
    for (int col = 0; col < groupQty; col ++ ) {
      for (int row =0; row < roundsQty; row ++) {
        if (bestlabGroupMatrix[row][col] != null) {
          matrxPos = bestlabGroupMatrix[row][col];
        }
        checkSumCol = checkSumCol + matrxPos.sumMembers();
      }
      String strCSV = str(checkSumCol);
      sbMsg2.append(strCSV);
      sbMsg2.append(spc(gw+cospc-strCSV.length()));
      checkSumCol = 0;
    }
    if (! atAppWindowOnly) {
      println(sbMsg2.toString());
    }
    text(sbMsg2.toString(), drawborder, nextLineY());
    nextLineY();
    // end of matrix

    // output the bestHist list, but mode could have been ruthless
    if (!modeRuthless) {
      printpropEstimate(0);
      printbestHistList(0);
    } else {
      if (doEstimateProp) {
        printpropEstimate(0);
      }
      text("Best history is not applicable in this mode.", drawborder, nextLineY());
    }
    return;
  }// end if (!modeRuthless || processCompleted)

  // The exception case
  if (modeRuthless && doEstimateProp ) {
    printpropEstimate(0);
  }// end if (modeRuthless && doEstimateProp )
}// end printBestResultsMatrix

// Display the warnings list
void outputWarnings() {
  for (String warn : warningsList) {
    text(warn, drawborder, currentlineY);
    nextLineY();
  }
  nextLineY();
}// end outputWarnings

// Increments current display output position
int nextLineY() {
  currentlineY = currentlineY + fontsize + vfontgap;
  return currentlineY;
}// end nextline

// Builds time message when process halted by user.
void reportQuitNowMessage(int trialRun) {
  // to do, needs to handle multiple trialRun instances. Currently reports
  // the duration of the stopped single last trial
  String runtype = new String();
  String timetype = new String();
  String strDuration = new String();
  if (doEstimateProp || doAutoFiling) {
    strDuration = timeElapsed(milliSStart, milliSEnd);
    runtype = "Session";
    timetype = "session";
  } else {
    strDuration = timeElapsed(milliTStart, milliTEnd);
    runtype = "Find";
    timetype = "trial";
  }
  msg = runtype + " terminated by keypress after trial " + nfc(trialRun) + " at " + timetype + " time " + strDuration + ".";
  isMsgFeedBack = true;
  println(msg);
  lastStatusMsg = msg;
  bestHistList.append(msg);
  if (doEstimateProp) {
    doEstimatePropIntoHistory();
  }
} // end reportQuitNowMessage

// Function to return a string of len spaces.
String spc(int len) {
  StringBuilder s = new StringBuilder();
  while (s.length() < len ) {
    s.append(" ");
  }
  return s.toString();
}// end spc

// Returns time duration seconds as formatted string.
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
}// end timeElapsed

// Report the unused LabGroups
// int whereTo is a switch for where the report goes.
// whereTo 0 = to console, whereTo 1 = to file
// atAppWindowOnly arg results in display
// to screen only..
void reportLeftOverGroups(boolean atAppWindowOnly, int whereTo) {
  PossibleGroupsK freshMstrPosGroups;
  StringBuilder sbRpt = new StringBuilder();
  int rm;
  if (atAppWindowOnly) {
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
}// end printlnWhereTo

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

// prints the bestHist list
// where=0 to window, where>0 to console
void printbestHistList(int where) {
  for (String h : bestHistList) {
    if (where < 1) {
      text(h, drawborder, nextLineY());
    } else {
      println(h);
    }
  }
}

// prints the propHist list
// where=0 to window, where>0 to console
void printpropEstimate(int where) {
  if (where < 1) {
    text(propEstimate, drawborder, nextLineY());
  } else {
    println(propEstimate);
  }
}
