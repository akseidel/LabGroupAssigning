// Misc. functions
// Meant to forecast results and inhibit running the process with bad
// conditions.
void classSizeCheck(GTextField source) {
  if (source.getText().equals(" ") ) {
    warningsList.clear();
    theWarning= "Check the proposed input fields. At least one is empty.";
    warningsList.append(theWarning);
    butStart.setEnabled(false);
    return;
  }

  int lclassSize = int(textfieldClassSize.getText());
  int lroundsQty = int(textfieldRoundsQTY.getText());
  int lgroupQty = int(textfieldGroupQty.getText());
  int lgSize = int(textfieldGSize.getText());
  int lpoolSize = (int)numCombOfKinN(lgSize, lclassSize);
  float rowBal = float(lgroupQty) - float(lclassSize)/float(lgSize);
  float colBal = float(lroundsQty) - float(lclassSize)/float(lgSize);
  int matrixSize = lgroupQty * lroundsQty;
  int unFilled = 0;  // default to totally filled

  // Exit when any fields are zero.
  if ( lclassSize*lroundsQty*lgroupQty*lgSize < 1 ) { 
    butStart.setEnabled(false);
    return;
  } else {
    // But do not enable start if currently in process.
    if ( processIsDone ) {
      butStart.setEnabled(true);
    }
  }

  warningsList.clear();

  // Predicting the best possible unfilled matrix slots.
  // The pool size must be larger than the matrix size. 
  // Lab group sizes of one student are a special case. Unfilled = matrix size - pool size when
  // pool size is less than matrix size when lab group size is one student. 
  // A row (round) or column (group) is called balanced when all the students are selected once
  // in a row and column. Unbalanced can be underfilled, ie not enough students, or overfilled,
  // ie too many students. Unbalanced underfilled results in empty matrix slots with no possible
  // solution. Unbalanced overfilled results in filled matrix slots but not with equal student
  // participation.  

  theWarning= "The proposed selection pool will be " + nfc(lpoolSize);
  warningsList.append(theWarning);

  if ((lgSize == 1) && (matrixSize > lpoolSize)) {
    unFilled = matrixSize - lpoolSize;
    theWarning= "The " + lpoolSize + " students cannot fill the " + matrixSize + " positions. " + unFilled + " will be unfilled.";
    warningsList.append(theWarning);
  } else {

    // examine row situation
    int rowUnder = 0;
    int rowOver = 0;
    if (rowBal ==0) {
      theWarning= "Group Qty. balances with Group Size into the Class Size.";
    } else if (rowBal > 0) {
      rowUnder = - round(rowBal);
      theWarning= "Too few students for a round. At least " + abs(rowUnder) + " matrix cell" + pls(abs(rowUnder)) + " in round will be empty.";
    } else { // rowBal < 0
      rowOver = round(-rowBal);
      theWarning= "Too many students for a round. At least " + abs(rowOver) + " student group" + pls(abs(rowOver)) + " in round will not participate.";
    } // fi
    warningsList.append(theWarning);

    // examine column situation
    int colUnder = 0;
    int colOver = 0;
    if (colBal ==0) {
      theWarning= "Rounds Qty. balances with Group Size into the Class Size.";
    } else if (colBal > 0) {
      colUnder = - round(colBal);  
      theWarning= "Too few students for a group (column). At least " + abs(colUnder) + " matrix cell" + pls(abs(colUnder)) + " in group will be empty.";
    } else { // colBal < 0
      colOver =  round(-colBal); 
      theWarning= "Too many students for a group. At least " + abs(colOver) + " student group" + pls(abs(colOver)) + " in group will not participate.";
    } // fi
    warningsList.append(theWarning);

    // Account for any unbalance
    if ( (rowUnder != 0) || (colUnder !=0) ) {
      unFilled = max(abs(rowUnder*lroundsQty), abs(colUnder*lgroupQty));
    } // fi

    if (unFilled > 0) {
      theWarning= "There will be roughly " + unFilled + " unfilled slots.";
      warningsList.append(theWarning);
    } // fi
  } // fi ((lgSize == 1) && (matrixSize > lpoolSize))

  // Disable starting when the pool is zero, which happens during
  // editing the textfield and could be left that way.
  if (lpoolSize < 1) {
    butStart.setEnabled(false);
  } else {
    // But do not enable start if currently in process.
    if ( processIsDone ) {
      butStart.setEnabled(true);
    }
  }

  propBestPossibleMin = unFilled ;
}

// Returns number of possible filled positions for a row or column
// given class size, group size & the column or row size.
int posFillsPerSlots(int classS, int gS, int slotQ) {
  // gS = 1 is special case that is indeterminate.
  if (gS < 2) { 
    return slotQ;
  }
  int comBos = (int)numCombOfKinN(gS, classS);
  int result = 0;
  while (comBos > 0) {
    result ++;
    classS = classS - gS;
    comBos = (int)numCombOfKinN(gS, classS);
  }
  return (slotQ - result);
}

// returns s for pluralizing words
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
