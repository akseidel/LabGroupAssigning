PrintWriter theFileOutput;
String theFileOutputName;
String runInfo;
StringBuilder sbDC = new StringBuilder();
StringBuilder sbFN = new StringBuilder();

void filePrint() {
  setupPrintJob();
  makeOutput();
  if (doAutoFiling) {
    surface.setTitle(windowTitle + " | Auto Save Result " + cATrial + " of " + autoFileQty + " as: "+ theFileOutputName);
  } else {
    surface.setTitle(windowTitle +" | Results saved to file: " + theFileOutputName);
  }
}

void setupPrintJob() {
  sbFN.setLength(0);
  sbFN.append("LGM_");
  sbFN.append(classSize);
  sbFN.append("_");
  sbFN.append(gSize);
  sbFN.append("_");
  sbFN.append(groupQty);
  sbFN.append("x");
  sbFN.append(roundsQty);
  sbFN.append("_");
  // date code
  sbDC.setLength(0);
  sbDC.append(year());
  sbDC.append("-");
  sbDC.append(month());
  sbDC.append("-");
  sbDC.append(day());
  sbDC.append("_");
  sbDC.append(hour());
  sbDC.append(minute());
  sbDC.append(second());
  sbDC.append("_");
  sbDC.append(millis());
  sbDC.append("+");
  sbDC.append(int(random(100)));
  sbFN.append(sbDC.toString());
  sbFN.append(".txt");
  theFileOutputName = sbFN.toString();
  theFileOutput = createWriter(theFileOutputName);
}

void makeOutput() {
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gSize*2)+(gSize-1);   // group text length
  int cospc = 4;                  // space between columns

  theFileOutput.println("Date: "+ sbDC.toString());
  theFileOutput.println();
  for (String warn : warningsList) {
    theFileOutput.println(warn);
  }
  theFileOutput.println();

  StringBuilder sbHDR = new StringBuilder();
  sbHDR.append("Class Size: ");
  sbHDR.append(classSize);
  sbHDR.append( "  # Groups: ");
  sbHDR.append(groupQty);
  sbHDR.append("  # Rounds: ");
  sbHDR.append(roundsQty);
  sbHDR.append( "  Group Size: ");
  sbHDR.append( gSize);
  sbHDR.append("  Pool Size ");
  sbHDR.append(nfc(poolSize));
  theFileOutput.println(sbHDR.toString());

  StringBuilder sbFBH = new StringBuilder();
  sbFBH.append("First best number of unfilled groups in ");
  sbFBH.append(nfc(trialQty));
  sbFBH.append(" trials. ");
  sbFBH.append(bestunfilledQty);
  sbFBH.append(" unfilled in trial: ");
  sbFBH.append(nfc(besttrialrun));
  theFileOutput.println(sbFBH.toString());

  theFileOutput.println();
  msg ="Lab Groups Matrix";
  theFileOutput.println(msg);

  StringBuilder sbMTX = new StringBuilder();
  sbMTX.append("Group ");
  sbMTX.append(spc(5));
  for (int col = 0; col < groupQty; col ++ ) {
    String strHN = str((col+1));
    sbMTX.append(strHN);
    sbMTX.append(spc(gw+cospc-strHN.length()));
  } 
  sbMTX.append("Chk:");
  theFileOutput.println(sbMTX.toString());

  for (int row =0; row < roundsQty; row ++) {
    sbMTX.setLength(0);
    sbMTX.append("Round ");
    sbMTX.append(nf((row+1), 2));
    sbMTX.append("   ");
    for (int col = 0; col < groupQty; col ++ ) {
      sbMTX.append(bestlabGroupMatrix[row][col].showMembers());
      sbMTX.append(spc(cospc));
      checkSumRow = checkSumRow + bestlabGroupMatrix[row][col].sumMembers();
    }
    sbMTX.append(checkSumRow);
    theFileOutput.println(sbMTX.toString());
    checkSumRow = 0;
  }

  sbMTX.setLength(0);
  sbMTX.append("Chk:");
  sbMTX.append(spc(7));
  for (int col = 0; col < groupQty; col ++ ) {
    for (int row =0; row < roundsQty; row ++) {
      checkSumCol = checkSumCol + bestlabGroupMatrix[row][col].sumMembers();
    }
    String strCSV = str(checkSumCol);
    sbMTX.append(strCSV);
    sbMTX.append(spc(gw+cospc-strCSV.length()));
    checkSumCol = 0;
  }
  theFileOutput.println(sbMTX.toString());

  theFileOutput.println();
  for (String h : historyList) {
    theFileOutput.println(h);
  }
  reportLeftOverGroups(false, 1);
  theFileOutput.flush();
  theFileOutput.close();
}
