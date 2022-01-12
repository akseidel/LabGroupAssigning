/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void butStart_click(GButton source, GEvent event) { //_CODE_:butStart:834095:
  doButtonStart();
} //_CODE_:butStart:834095:

public void butStop_click(GButton source, GEvent event) { //_CODE_:butStop:445414:
  doButtonStop();
} //_CODE_:butStop:445414:

public void textfieldClassSizez(GTextField source, GEvent event) { //_CODE_:textfieldClassSize:634606:
  //println("textfieldClassSize - GTextField >> GEvent." + event + " @ " + millis());
  classSizeCheck(source);
} //_CODE_:textfieldClassSize:634606:

public void textfieldGSize_change(GTextField source, GEvent event) { //_CODE_:textfieldGSize:638248:
  //println("textfieldGSize - GTextField >> GEvent." + event + " @ " + millis());
  classSizeCheck(source);
} //_CODE_:textfieldGSize:638248:

public void textfieldGroupQty_change(GTextField source, GEvent event) { //_CODE_:textfieldGroupQty:614562:
  //println("textfieldGroupQty - GTextField >> GEvent." + event + " @ " + millis());
  classSizeCheck(source);
} //_CODE_:textfieldGroupQty:614562:

public void textfieldRoundsQty_change(GTextField source, GEvent event) { //_CODE_:textfieldRoundsQTY:785325:
  //println("textfieldRoundsQTY - GTextField >> GEvent." + event + " @ " + millis());
  classSizeCheck(source);
} //_CODE_:textfieldRoundsQTY:785325:

public void buttonQuit_click(GButton source, GEvent event) { //_CODE_:butQuit:798976:
  //println("butQuit - GButton >> GEvent." + event + " @ " + millis());
  doButtonQuit();
} //_CODE_:butQuit:798976:

public void butPrint_click(GButton source, GEvent event) { //_CODE_:butPrint:714479:
  //println("butPrint - GButton >> GEvent." + event + " @ " + millis());
  filePrint("Manual-saved");
} //_CODE_:butPrint:714479:

public void chkAutoFile_clicked1(GCheckbox source, GEvent event) { //_CODE_:chkAutoFile:322035:
  //println("chkAutoFile - GCheckbox >> GEvent." + event + " @ " + millis());
  doChkAutoFileClicked(event);
} //_CODE_:chkAutoFile:322035:

public void textfieldAuto_change1(GTextField source, GEvent event) { //_CODE_:textfieldAuto:872339:
  //println("textfieldAuto - GTextField >> GEvent." + event + " @ " + millis()); 
  if (event ==GEvent.LOST_FOCUS){
    source.setText(str(autoFileQty));
   return; 
  }
  autoFileQtyCheck(source);
} //_CODE_:textfieldAuto:872339:


public void textfieldEstP_change1(GTextField source, GEvent event) { 
  //println("textfieldEstP - GTextField >> GEvent." + event + " @ " + millis()); 
  if (event ==GEvent.LOST_FOCUS){
    source.setText(str(source.getValueI()));
    return; 
  }
  textfieldEstPCheck(source);
} 

public void chkUnused_clicked1(GCheckbox source, GEvent event) { //_CODE_:chkUnused:542584:
  //println("chkUnused - GCheckbox >> GEvent." + event + " @ " + millis());
  doChkSaveUnusedClicked( event);
} //_CODE_:chkUnused:542584:

public void optDoEstimate_clicked1(GOption source, GEvent event) { 
  //println("optDoEstimate - GOption >> GEvent." + event + " @ " + millis());
  doOptDoEstimateClicked( event);
}



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  butStart = new GButton(this, 889, 10, 80, 30);
  butStart.setText("Start");
  butStart.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  butStart.addEventHandler(this, "butStart_click");
  butStop = new GButton(this, 804, 10, 80, 30);
  butStop.setText("Stop");
  butStop.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  butStop.addEventHandler(this, "butStop_click");
  labClassSize = new GLabel(this, 672, 12, 80, 20);
  labClassSize.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labClassSize.setText("Class Size");
  labClassSize.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  labClassSize.setOpaque(false);
  labGSize = new GLabel(this, 672, 38, 80, 20);
  labGSize.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labGSize.setText("Group Size");
  labGSize.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  labGSize.setOpaque(false);
  textfieldClassSize = new GTextField(this, 762, 12, 36, 20, G4P.SCROLLBARS_NONE);
  textfieldClassSize.setNumericType(G4P.INTEGER);
  textfieldClassSize.setText("24");
  textfieldClassSize.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfieldClassSize.setOpaque(true);
  textfieldClassSize.addEventHandler(this, "textfieldClassSizez");
  textfieldGSize = new GTextField(this, 762, 38, 36, 20, G4P.SCROLLBARS_NONE);
  textfieldGSize.setNumericType(G4P.INTEGER);
  textfieldGSize.setText("2");
  textfieldGSize.setPromptText("Group Size");
  textfieldGSize.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfieldGSize.setOpaque(true);
  textfieldGSize.addEventHandler(this, "textfieldGSize_change");
  labTaskQty = new GLabel(this, 672, 64, 80, 20);
  labTaskQty.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labTaskQty.setText("Group Qty");
  labTaskQty.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  labTaskQty.setOpaque(false);
  textfieldGroupQty = new GTextField(this, 762, 64, 36, 20, G4P.SCROLLBARS_NONE);
  textfieldGroupQty.setNumericType(G4P.INTEGER);
  textfieldGroupQty.setText("12");
  textfieldGroupQty.setPromptText("Enter the number of groups. (matrix columns)");
  textfieldGroupQty.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfieldGroupQty.setOpaque(true);
  textfieldGroupQty.addEventHandler(this, "textfieldGroupQty_change");
  labRoundsQty = new GLabel(this, 672, 90, 80, 20);
  labRoundsQty.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labRoundsQty.setText("Rounds Qty");
  labRoundsQty.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  labRoundsQty.setOpaque(false);
  textfieldRoundsQTY = new GTextField(this, 762, 90, 36, 20, G4P.SCROLLBARS_NONE);
  textfieldRoundsQTY.setNumericType(G4P.INTEGER);
  textfieldRoundsQTY.setText("12");
  textfieldRoundsQTY.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfieldRoundsQTY.setOpaque(true);
  textfieldRoundsQTY.addEventHandler(this, "textfieldRoundsQty_change");
  butQuit = new GButton(this, 889, 46, 80, 30);
  butQuit.setText("Quit");
  butQuit.setLocalColorScheme(GCScheme.RED_SCHEME);
  butQuit.addEventHandler(this, "buttonQuit_click");
  butPrint = new GButton(this, 890, 83, 80, 30);
  butPrint.setText("File");
  butPrint.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  butPrint.addEventHandler(this, "butPrint_click");
  chkAutoFile = new GCheckbox(this, 762, 123, 206, 30);
  chkAutoFile.setIconAlign(GAlign.LEFT, GAlign.CENTER);
  chkAutoFile.setText(" Auto-Save Solutions");
  chkAutoFile.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  chkAutoFile.setOpaque(false);
  chkAutoFile.addEventHandler(this, "chkAutoFile_clicked1");
  textfieldAuto = new GTextField(this, 762, 150, 36, 20, G4P.SCROLLBARS_NONE);
  textfieldAuto.setNumericType(G4P.INTEGER);
  textfieldAuto.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfieldAuto.setOpaque(true);
  textfieldAuto.addEventHandler(this, "textfieldAuto_change1");
  labelAutoTrials = new GLabel(this, 804, 144, 200, 30);
  labelAutoTrials.setTextAlign(GAlign.LEFT, GAlign.CENTER);
  labelAutoTrials.setText("Auto-Saved Solutions Qty");
  labelAutoTrials.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  labelAutoTrials.setOpaque(false);
  chkUnused = new GCheckbox(this, 762, 168, 206, 30);
  chkUnused.setIconAlign(GAlign.LEFT, GAlign.CENTER);
  chkUnused.setText(" Report Unused In File/Console");
  chkUnused.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  chkUnused.setOpaque(false);
  chkUnused.addEventHandler(this, "chkUnused_clicked1"); 
  optDoEstimate = new GOption(this, 762, 200, 206, 30,"Do A Porportion Estimate");
  optDoEstimate.setIconAlign(GAlign.LEFT, GAlign.CENTER);
  optDoEstimate.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  optDoEstimate.setOpaque(false);
  optDoEstimate.addEventHandler(this, "optDoEstimate_clicked1");
  textfieldEstP = new GTextField(this, 762, 226, 80, 20, G4P.SCROLLBARS_NONE);
  textfieldEstP.setNumericType(G4P.INTEGER);
  textfieldEstP.setNumeric(minSampAbs,100000,minSampAbs);
  textfieldEstP.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfieldEstP.setOpaque(true);
  textfieldEstP.addEventHandler(this, "textfieldEstP_change1");
  labelEstP = new GLabel(this, 762, 242, 200, 30);
  labelEstP.setTextAlign(GAlign.LEFT, GAlign.CENTER);
  labelEstP.setText("Solution Qty. Basis For Estimate");
  labelEstP.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  labelEstP.setOpaque(false);
  
}

// Variable declarations 
// autogenerated do not edit
GButton butStart; 
GButton butStop; 
GLabel labClassSize; 
GLabel labGSize; 
GTextField textfieldClassSize; 
GTextField textfieldGSize; 
GLabel labTaskQty; 
GTextField textfieldGroupQty; 
GLabel labRoundsQty; 
GTextField textfieldRoundsQTY; 
GButton butQuit; 
GButton butPrint; 
GCheckbox chkAutoFile; 
GTextField textfieldAuto; 
GLabel labelAutoTrials; 
GCheckbox chkUnused;
GOption optDoEstimate;
GTextField textfieldEstP;
GLabel labelEstP;
