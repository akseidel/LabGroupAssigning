PrintWriter theFileOutput;
String theFileOutputName;
String timeCode;

void filePrint(){
  setupPrintJob();
  makeOutput();
  String msg = " | Results saved to file: " + theFileOutputName;
  surface.setTitle(windowTitle + msg);
}

void setupPrintJob() {
  timeCode = year()+"-" +month()+"-"+day()+"_"+hour()+minute() + second();
  theFileOutputName = "LabGroupMatrix." + timeCode + ".txt";
  theFileOutput = createWriter(theFileOutputName);
}

void makeOutput() {
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gSize*2)+(gSize-1);   // group text length
  int cospc = 4;                  // space between columns

  theFileOutput.println("Date: "+ timeCode);
  theFileOutput.println();
  for (String warn : warningsList) {
    theFileOutput.println(warn);
  }
  theFileOutput.println();
  msg = "Class Size: " + classSize + "  # Groups: " + groupQty + "  # Rounds: " + roundsQty + "  Group Size: " + gSize + "  Pool Size " + nfc(poolSize);
  theFileOutput.println(msg);
  msg ="First best number of unfilled groups in "+ nfc(trialQty) + " trials. "+ bestunfilledQty+ " unfilled in trial: "+ nfc(besttrialrun) + " at " + timeElapsed(milliStart,milliEnd);
  theFileOutput.println(msg);
  theFileOutput.println();
  msg ="Lab Groups Matrix";
  theFileOutput.println(msg);

  msg = "Group " + spc(5);
  for (int col = 0; col < groupQty; col ++ ) {
    String strHN = str((col+1));
    msg = msg +  strHN  + spc(gw+cospc-strHN.length())  ;
  } 
  msg = msg + "Chk:"   ;
  theFileOutput.println(msg);

  for (int row =0; row < roundsQty; row ++) {
    msg = "Round " + nf((row+1), 2) + spc(3);
    for (int col = 0; col < groupQty; col ++ ) {
      msg = msg + bestlabGroupMatrix[row][col].showMembers() + spc(cospc);
      checkSumRow = checkSumRow + bestlabGroupMatrix[row][col].sumMembers();
    }
    msg = msg + checkSumRow;
    theFileOutput.println(msg);
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
  theFileOutput.println(msg);
  theFileOutput.println();
  for (String h : historyList){
    theFileOutput.println(h);
  }
  reportLeftOverGroups(false,1);
  theFileOutput.flush();
  theFileOutput.close();
}
