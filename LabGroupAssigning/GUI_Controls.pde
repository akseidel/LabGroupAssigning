void doButtonStart() {
  processIsDone = false;
  quitNow = false;
  classSize = int(textfieldClassSize.getText());
  roundsQty = int(textfieldRoundsQTY.getText());
  groupQty = int(textfieldGroupQty.getText());
  gSize = int(textfieldGSize.getText());
  besttrialrun = 0;         
  bestunfilledQty = roundsQty * groupQty;
  noSolLG = defNoSolLG(gSize);
  poolSize = numCombOfKinN(gSize, classSize);
  stopConsoleOutput = false;
  thread("DoStartProcess");
}

void doButtonStop() {
  quitNow = true;
}

void doButtonQuit() {
  exit();
}
