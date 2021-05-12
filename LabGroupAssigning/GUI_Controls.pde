// Functions related to the GUI
int lastWidth;
int lastHeight;

void initGUI() {
  textfieldGSize.setText(str(gSize));
  textfieldClassSize.setText(str(classSize));
  textfieldRoundsQTY.setText(str(roundsQty));
  textfieldGroupQty.setText(str(groupQty));
  setButtonRunState(true); // App is running when started.
}

// setButtonRunState - Sets GUI button enabled state
// as appropriet to current running state.
void setButtonRunState(boolean isRunning) {
  int lclassSize = int(textfieldClassSize.getText());
  if (lclassSize > 1) {
    butStart.setEnabled(!isRunning);
  }
  butStop.setEnabled(isRunning);
}

// moves G4P controls as window is resized
void checkOnWindowResize() {
  boolean resized = false;
  float wDelta = 0;
  if ( (lastWidth != width)  ) {
    wDelta = width - lastWidth;
    lastWidth = width;
    resized = true;
  }
  if (resized) {
    //println(width,height);     
    reposControl(butStart, wDelta);
    reposControl(butQuit, wDelta);
    reposControl(butStop, wDelta);

    reposControl(textfieldClassSize, wDelta);
    reposControl(textfieldGSize, wDelta);
    reposControl(textfieldGroupQty, wDelta);
    reposControl(textfieldRoundsQTY, wDelta);

    reposControl(labClassSize, wDelta);
    reposControl(labGSize, wDelta);
    reposControl(labTaskQty, wDelta);
    reposControl(labRoundsQty, wDelta);
  }
}

void reposControl(GAbstractControl thisC, float wDelta) {
  thisC.moveTo(thisC.getX()+ wDelta, thisC.getY());
}

void doButtonStart() {
  processIsDone = false;
  quitNow = false;
  getGUITextFields();
  besttrialrun = 0;         
  bestunfilledQty = roundsQty * groupQty;
  noSolLG = defNoSolLG(gSize);
  stopConsoleOutput = false;
  setButtonRunState(true); 
  thread("DoStartProcess");
}

void getGUITextFields() {
  classSize = int(textfieldClassSize.getText());
  roundsQty = int(textfieldRoundsQTY.getText());
  groupQty = int(textfieldGroupQty.getText());
  gSize = int(textfieldGSize.getText());
}

void doButtonStop() {
  setButtonRunState(false);
  quitNow = true;
}

void doButtonQuit() {  
  exit();
}
