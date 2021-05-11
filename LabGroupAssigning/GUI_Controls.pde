// Functions related to the GUI
int lastWidth;
int lastHeight;
float butStartX = 889;
float butStartY = 10;
float butQuitX = 889;
float butQuitY = 46;
float butStopX = 804;
float butStopY = 10;

float txfClassSizeX = 762;
float txfClassSizeY = 12;
float txfGSizeX = 762;    
float txfGSizeY = 38;
float txfGroupQtyX = 762;
float txfGroupQtyY = 64;
float txfRoundsQtyX = 762;
float txfRoundsQtyY = 90;

float labClassSizeX = 672;
float labClassSizeY =12;
float labGSizeX = 672;
float labGSizeY = 38;
float labTaskQtyX = 672;
float labTaskQtyY = 64;
float labRoundsQtyX =672;
float labRoundsQtyY = 90;

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
    butStartX = butStartX + wDelta;
    butQuitX = butQuitX + wDelta;
    butStopX = butStopX + wDelta;
    txfClassSizeX = txfClassSizeX + wDelta;
    txfGSizeX = txfGSizeX + wDelta;
    txfGroupQtyX = txfGroupQtyX + wDelta;
    txfRoundsQtyX = txfRoundsQtyX + wDelta;
    labClassSizeX = labClassSizeX + wDelta;
    labGSizeX = labGSizeX + wDelta;
    labTaskQtyX = labTaskQtyX + wDelta;
    labRoundsQtyX = labRoundsQtyX + wDelta;

    butStart.moveTo((butStartX ), butStartY);
    butQuit.moveTo(butQuitX, butQuitY);
    butStop.moveTo(butStopX, butStopY);

    textfieldClassSize.moveTo( txfClassSizeX, txfClassSizeY);
    textfieldGSize.moveTo( txfGSizeX, txfGSizeY);
    textfieldGroupQty.moveTo(txfGroupQtyX, txfGroupQtyY);
    textfieldRoundsQTY.moveTo(txfRoundsQtyX, txfRoundsQtyY);

    labClassSize.moveTo( labClassSizeX, labClassSizeY);  
    labGSize.moveTo( labGSizeX, labGSizeY);
    labTaskQty.moveTo(labTaskQtyX, labTaskQtyY);
    labRoundsQty.moveTo(labRoundsQtyX, labRoundsQtyY);
  }
}
void doButtonStart() {
  processIsDone = false;
  quitNow = false;
  getGUITextFields();
  besttrialrun = 0;         
  bestunfilledQty = roundsQty * groupQty;
  noSolLG = defNoSolLG(gSize);
  stopConsoleOutput = false;
  thread("DoStartProcess");
}

void getGUITextFields() {
  classSize = int(textfieldClassSize.getText());
  roundsQty = int(textfieldRoundsQTY.getText());
  groupQty = int(textfieldGroupQty.getText());
  gSize = int(textfieldGSize.getText());
}

void doButtonStop() {
  quitNow = true;
}

void doButtonQuit() {
  exit();
}
