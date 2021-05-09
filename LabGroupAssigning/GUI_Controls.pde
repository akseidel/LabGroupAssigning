void doButtonStart() {
  processIsDone = false;
  quitNow = false;
  classSize = int(textfieldClassSize.getText());
  roundsQty = int(textfieldRoundsQTY.getText());
  groupQty = int(textfieldGroupQty.getText());
  gsize = int(textfieldGSize.getText());
  besttrialrun = 0;         
  bestunfilledQty = roundsQty * groupQty;
  noSolLG = defNoSolLG(gsize);
  stopConsoleOutput = false;
  thread("DoStartProcess");
}

void doButtonStop() {
  quitNow = true;
}

void doButtonQuit() {
  exit();
}
