// Functions related to the GUI
int lastWidth;
int lastHeight;
ArrayList<GAbstractControl> g4pStuff = new ArrayList();

void initGUI() {
  textfieldGSize.setText(str(gSize));
  textfieldClassSize.setText(str(classSize));
  textfieldRoundsQTY.setText(str(roundsQty));
  textfieldGroupQty.setText(str(groupQty));
  setButtonRunEnableState(true); // App is running when started.
  // g4pStuff is for iterating when window is resized
  g4pStuff.add(butStart);
  g4pStuff.add(butQuit);
  g4pStuff.add(butStop);
  g4pStuff.add(butPrint);
  g4pStuff.add(textfieldClassSize);
  g4pStuff.add(textfieldGSize);
  g4pStuff.add(textfieldGroupQty);
  g4pStuff.add(textfieldRoundsQTY);
  g4pStuff.add(labClassSize);
  g4pStuff.add(labGSize);
  g4pStuff.add(labTaskQty);
  g4pStuff.add(labRoundsQty);
}

// setButtonRunState - Sets GUI button enabled state
// as appropriet to current running state.
void setButtonRunEnableState(boolean isRunning) {
  int lclassSize = int(textfieldClassSize.getText());
  if (lclassSize > 1) {
    butStart.setEnabled(!isRunning);
  }
  butStop.setEnabled(isRunning);
  butPrint.setEnabled(!isRunning);
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
    for(int i=0; i < g4pStuff.size(); i++){
      GAbstractControl cntl = g4pStuff.get(i);
      reposControl(cntl, wDelta);
    }
  }
}

void reposControl(GAbstractControl thisC, float wDelta) {
  thisC.moveTo(thisC.getX()+ wDelta, thisC.getY());
}

void doButtonStart() {
  surface.setTitle(windowTitle);
  processIsDone = false;
  quitNow = false;
  getGUITextFields();
  besttrialrun = 0;         
  bestunfilledQty = roundsQty * groupQty;
  noSolLG = defNoSolLG(gSize);
  stopConsoleOutput = false;
  setButtonRunEnableState(true);
  thread("DoStartProcess");
}

void getGUITextFields() {
  classSize = int(textfieldClassSize.getText());
  roundsQty = int(textfieldRoundsQTY.getText());
  groupQty = int(textfieldGroupQty.getText());
  gSize = int(textfieldGSize.getText());
}

void doButtonStop() {
  surface.setTitle(windowTitle);
  setButtonRunEnableState(false);
  quitNow = true;
}

void doButtonQuit() {  
  exit();
}
