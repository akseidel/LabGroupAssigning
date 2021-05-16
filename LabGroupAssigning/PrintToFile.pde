PrintWriter theOutput;
String timeCode;

void filePrint(){
  setupPrintJob();
  makeOutput();
}

void setupPrintJob() {
  timeCode = year()+"-" +month()+"-"+day()+"_"+hour()+minute() + second();
  String theOutputName = "LabGroupMatrix." + timeCode + ".txt";
  theOutput = createWriter(theOutputName);
}

void makeOutput() {
  int checkSumRow = 0;
  int checkSumCol = 0;
  int gw = (gSize*2)+(gSize-1);   // group text length
  int cospc = 4;                  // space between columns

  theOutput.println("Date: "+ timeCode);
  theOutput.println();
  for (String warn : warningsList) {
    theOutput.println(warn);
  }
  theOutput.println();
  msg = "Class Size: " + classSize + "  # Groups: " + groupQty + "  # Rounds: " + roundsQty + "  Group Size: " + gSize + "  Pool Size " + poolSize;
  theOutput.println(msg);
  msg ="First best number of unfilled groups in "+ trialQty+ " runs. "+ bestunfilledQty+ " unfilled in Run #:"+ besttrialrun ;
  theOutput.println(msg);
  theOutput.println();
  msg ="Lab Groups Matrix";
  theOutput.println(msg);

  msg = "Group " + spc(5);
  for (int col = 0; col < groupQty; col ++ ) {
    String strHN = str((col+1));
    msg = msg +  strHN  + spc(gw+cospc-strHN.length())  ;
  } 
  msg = msg + "Chk:"   ;
  theOutput.println(msg);

  for (int row =0; row < roundsQty; row ++) {
    msg = "Round " + nf((row+1), 2) + spc(3);
    for (int col = 0; col < groupQty; col ++ ) {
      msg = msg + bestlabGroupMatrix[row][col].showMembers() + spc(cospc);
      checkSumRow = checkSumRow + bestlabGroupMatrix[row][col].sumMembers();
    }
    msg = msg + checkSumRow;
    theOutput.println(msg);
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
  theOutput.println(msg);
  theOutput.flush();
  theOutput.close();
}
