// Functions related to the GUI //<>//
int lastWidth;
int lastHeight;
ArrayList<GAbstractControl> g4pStuff = new ArrayList();

void initGUI() {
  textfieldGSize.setText(str(gSize));
  textfieldClassSize.setText(str(classSize));
  textfieldRoundsQTY.setText(str(roundsQty));
  textfieldGroupQty.setText(str(groupQty));
  textfieldAuto.setText(str(autoFileQty));
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
  g4pStuff.add(labelAutoTrials);
  g4pStuff.add(textfieldAuto);
  g4pStuff.add(chkAutoFile);
  g4pStuff.add(chkUnused);
  g4pStuff.add(chkDoEstimate);
}

// setButtonRunState - Sets GUI button enabled state
// as appropriet to current running state.
void setButtonRunEnableState(boolean isRunning) {
  int lclassSize = int(textfieldClassSize.getText());
  if (lclassSize > 1) {
    butStart.setEnabled(!isRunning);
    chkDoEstimate.setEnabled(!isRunning);
  }
  butStop.setEnabled(isRunning);
  chkDoEstimate.setEnabled(!isRunning);
}

// moves G4P controls as window is resized
void checkForUserWindowResize() {
  boolean resized = false;
  float wDelta = 0;
  if ( (lastWidth != width)  ) {
    wDelta = width - lastWidth;
    lastWidth = width;
    resized = true;
  }
  if (resized) {
    for (int i=0; i < g4pStuff.size(); i++) {
      GAbstractControl cntl = g4pStuff.get(i);
      reposControl(cntl, wDelta);
    }
  }
}

void reposControl(GAbstractControl thisC, float wDelta) {
  thisC.moveTo(thisC.getX()+ wDelta, thisC.getY());
}

void doButtonStart() {
  println(); // balnk line needed at console
  surface.setTitle(windowTitle);
  processCompleted = false;
  processWasQuit = false;
  getGUITextFields();
  besttrialrun = 0;         
  bestunfilledQty = roundsQty * groupQty;
  noSolLG = defNoSolLG(gSize);
  initEstPorp();
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
  processWasQuit = true;
}

void doButtonQuit() {  
  exit();
}

// For some reason the textfield cannot be set within this call. 
void autoFileQtyCheck(GTextField source) {
  if (source.getText().equals(" ") ) {
    return;
    // Otherwise there will be null errors for anything beyond this.
  }
  autoFileQty = int(source.getText());
  if (autoFileQty < 1) {
    autoFileQty = 1;
  }
}

void  doChkAutoFileClicked( GEvent event) {
  if (event ==GEvent.SELECTED) {
    doAutoFiling = true;
    return;
  }
  if (event ==GEvent.DESELECTED) {
    doAutoFiling = false;
    return;
  }
}

void  doChkSaveUnusedClicked( GEvent event) {
  if (event ==GEvent.SELECTED) {
    doUnused = true;
    return;
  }
  if (event ==GEvent.DESELECTED) {
    doUnused = false;
    return;
  }
}

void doChkDoEstimateClicked( GEvent event){
  if (event ==GEvent.SELECTED) {
    doEstimatePorp = true;
    chkDoEstimate.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    return;
  }
  if (event ==GEvent.DESELECTED) {
    doEstimatePorp = false;
    chkDoEstimate.setLocalColorScheme(GCScheme.CYAN_SCHEME);
    return;
  }
}
