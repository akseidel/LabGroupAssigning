// Misc. functions

void classSizeCheck() {
  theWarning = ""; 
  int lclassSize = int(textfieldClassSize.getText());
  int lroundsQty = int(textfieldRoundsQTY.getText());
  int lgroupQty = int(textfieldGroupQty.getText());
  int lgSize = int(textfieldGSize.getText());

  if ( lclassSize*lroundsQty*lgroupQty*lgSize < 1 ) { 
    return;
  }

  int lpoolSize = (int)numCombOfKinN(lgSize, lclassSize);
  int lbestUnfilledRowQty = posFillsPerSlots(lclassSize, lgSize, lgroupQty);
  int lbestUnfilledColQty = posFillsPerSlots(lclassSize, lgSize, lroundsQty);

  warningsList.clear();

  if ( lbestUnfilledRowQty > 0) {
    theWarning= "Warning: Selection pool (" + lpoolSize + ") is too small. At least " + lbestUnfilledRowQty + " slot" +pls(lbestUnfilledRowQty) + " per row will be unassigned.";
    warningsList.append(theWarning);
  }

  if ( lbestUnfilledColQty > 0) {
    theWarning= "Warning: Selection pool (" + lpoolSize + ") is too small. At least " + lbestUnfilledColQty + " slot" + pls(lbestUnfilledColQty) + " per column will be unassigned.";
    warningsList.append(theWarning);
  }

  if ( lbestUnfilledRowQty > 0 || lbestUnfilledColQty > 0) {
    int unFilled = max(lbestUnfilledRowQty*lroundsQty, lbestUnfilledColQty*lgroupQty);
    bestPossibleMin = unFilled ;
    theWarning= "Warning: There will be " + unFilled + " unfilled";
    warningsList.append(theWarning);
  }

  // Disable starting when the pool is zero
  if (lpoolSize < 1) {
    butStart.setEnabled(false);
  } else {
    butStart.setEnabled(true);
  }
}

int posFillsPerSlots(int classS, int gS, int slotQ) {
  int comBos = (int)numCombOfKinN(gS, classS);
  if (gS < 2) { 
    return comBos;
  }
  int result = 0;
  while (comBos > 0) {
    result ++;
    classS = classS - gS;
    comBos = (int)numCombOfKinN(gS, classS);
  }
  return (slotQ - result);
}

// returns s for plural val
String pls(int val) {
  if (val > 1) {
    return "s";
  } else { 
    return "";
  }
}

// Returns number of combinations of k members that can be chosen
// from a population of n members. Combinations with different order
// are considered the same combination.
public static double numCombOfKinN(int k, int n) {
  if (k < 2) { 
    return (double)n;
  }
  double result = factorial(n)/(factorial(k)*factorial(n-k));
  return result;
}

// Returns the factorial of a number. This needs to be a float.
public static double factorial(int number) {
  if (number <= 1) { 
    return 1;
  } else {
    return number * factorial(number - 1);
  }
}
