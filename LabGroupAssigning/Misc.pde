// Misc. functions

void classSizeCheck(){
  theWarning = ""; 
  isWarning = false;
  int lclassSize = int(textfieldClassSize.getText());
  int lroundsQty = int(textfieldRoundsQTY.getText());
  int lgroupQty = int(textfieldGroupQty.getText());
  int lgSize = int(textfieldGSize.getText());
  
  if (lclassSize < lgSize*max(lgroupQty,lroundsQty)){
    theWarning="Warning - There will not be enough lab group combinations to completly fill the matrix.";
    isWarning = true;
  }
}
