// Misc. functions

// Predicting the best possible unfilled matrix slots.
// The pool size must be larger than the matrix size.
// Lab group sizes of one student are a special case. Unfilled = matrix size - pool size when
// pool size is less than matrix size when lab group size is one student.
// A row (round) or column (group) is called balanced when all the students are selected once
// in a row and column. Unbalanced can be underfilled, ie not enough students, or overfilled,
// ie too many students. Unbalanced underfilled results in empty matrix slots with no possible
// solution. Unbalanced overfilled results in filled matrix slots but not with equal student
// participation.
// Meant to forecast results and inhibit running the process with bad conditions.
void classSizeCheck(GTextField source) {
  StringBuilder sbTheWarning = new StringBuilder();

  if (source.getText().equals(" ") ) {
    warningsList.clear();
    sbTheWarning.append("Check the proposed input fields. At least one is empty.");
    warningsList.append(sbTheWarning.toString());
    butStart.setEnabled(false);
    return;
    // Otherwise there will be null errors for anything beyond this.
  }

  int lclassSize = int(textfieldClassSize.getText());
  int lroundsQty = int(textfieldRoundsQTY.getText());
  int lgroupQty = int(textfieldGroupQty.getText());
  int lgSize = int(textfieldGSize.getText());
  int lpoolSize = round(numCombOfKinN(lgSize, lclassSize));
  float rowBal = float(lgroupQty) - float(lclassSize)/float(lgSize);
  float colBal = float(lroundsQty) - float(lclassSize)/float(lgSize);
  int rowOrphans = lclassSize - lgroupQty*lgSize;
  int colOrphans = lclassSize - lroundsQty*lgSize;
  int matrixSize = lgroupQty * lroundsQty;
  float poolRatio = (float)lpoolSize/matrixSize;
  int unFilled = 0;  // default to totally filled

  // Exit when any fields are zero.
  if ( lclassSize*lroundsQty*lgroupQty*lgSize < 1 ) {
    butStart.setEnabled(false);
    return;
  } else {
    // But do not enable start if currently in process.
    // ie. ok only when completed or quitted.
    if ( processCompleted || processWasQuit ) {
      butStart.setEnabled(true);
    }
  }

  warningsList.clear();
  sbTheWarning.setLength(0);
  sbTheWarning.append("The proposed selection pool will be ");
  sbTheWarning.append(nfc(lpoolSize));
  sbTheWarning.append(" , Pool Ratio: ");
  sbTheWarning.append(nfc(poolRatio, 2));
  sbTheWarning.append(":1");
  warningsList.append(sbTheWarning.toString());
  areBalWarn = false;
  if ((lgSize == 1) && (matrixSize > lpoolSize)) {
    unFilled = matrixSize - lpoolSize;
    theWarning= "The " + lpoolSize + " students cannot fill the " + matrixSize + " positions. " + unFilled + " will be unfilled.";
    sbTheWarning.setLength(0);
    sbTheWarning.append("The ");
    sbTheWarning.append(nfc(lpoolSize));
    sbTheWarning.append( " students cannot fill the ");
    sbTheWarning.append(matrixSize );
    sbTheWarning.append(" positions. ");
    sbTheWarning.append( unFilled);
    sbTheWarning.append( " will be unfilled.");
    warningsList.append(sbTheWarning.toString());
    areBalWarn = true;
  } else {
    // examine row situation
    int rowUnder = 0;
    int rowOver = 0;
    sbTheWarning.setLength(0);
    if (rowBal ==0) {
      sbTheWarning.append( "Group Qty. balances with Group Size into the Class Size.");
    } else if (rowBal > 0) {
      rowUnder = - round(rowBal);
      sbTheWarning.append("Too few students for rounds. At least ");
      sbTheWarning.append(abs(rowUnder));
      sbTheWarning.append(" matrix cell");
      sbTheWarning.append(pls(abs(rowUnder)));
      sbTheWarning.append(" in round will be empty.");
      areBalWarn = true;
    } else { // rowBal < 0
      rowOver = round(abs(rowBal));
      sbTheWarning.append("Too many students for rounds. At least ");
      sbTheWarning.append(rowOver);
      sbTheWarning.append(" student group");
      sbTheWarning.append(pls(rowOver));
      sbTheWarning.append(" (");
      sbTheWarning.append(rowOrphans);
      sbTheWarning.append(" std) will not participate.");
      areBalWarn = true;
    } // fi
    warningsList.append(sbTheWarning.toString());
    // examine column situation
    int colUnder = 0;
    int colOver = 0;
    sbTheWarning.setLength(0);
    if (colBal ==0) {
      sbTheWarning.append("Rounds Qty. balances with Group Size into the Class Size.");
    } else if (colBal > 0) {
      colUnder = - round(colBal);
      sbTheWarning.append("Too few students for groups (column). At least ");
      sbTheWarning.append(abs(colUnder));
      sbTheWarning.append(" matrix cell");
      sbTheWarning.append(pls(abs(colUnder)));
      sbTheWarning.append(" in group will be empty.");
      areBalWarn = true;
    } else { // colBal < 0
      colOver =  round(abs(colBal));
      sbTheWarning.append("Too many students for groups. At least ");
      sbTheWarning.append(colOver);
      sbTheWarning.append(" student group");
      sbTheWarning.append(pls(colOver));
      sbTheWarning.append(" (");
      sbTheWarning.append(colOrphans);
      sbTheWarning.append(" std) will not participate.");
      areBalWarn = true;
    } // fi
    warningsList.append(sbTheWarning.toString());

    // Account for any unbalance
    if ( (rowUnder != 0) || (colUnder !=0) ) {
      unFilled = max(abs(rowUnder*lroundsQty), abs(colUnder*lgroupQty));
    } // fi

    if (unFilled > 0) {
      sbTheWarning.setLength(0);
      sbTheWarning.append("There will be roughly ");
      sbTheWarning.append(unFilled);
      sbTheWarning.append(" unfilled slots.");
      warningsList.append(sbTheWarning.toString());
    } // fi
  } // fi ((lgSize == 1) && (matrixSize > lpoolSize))

  // Disable starting when the pool is zero, which happens during
  // editing the textfield and could be left that way.
  if (lpoolSize < 1) {
    butStart.setEnabled(false);
  } else {
    // But do not enable start if currently in process.
    if ( processCompleted ) {
      butStart.setEnabled(true);
    }
  }
  // projected best possible allows for unbalanced
  projBestPossibleMin = unFilled + 1;
}// end classSizeCheck(GTextField source)

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
public static float numCombOfKinN(int k, int n) {
  if (k < 2) {
    return (float)n;
  }
  float result = factorial(n)/(factorial(k)*factorial(n-k));
  return result;
}

// Returns the factorial of a number. This needs to be a float.
public static float factorial(int number) {
  if (number <= 1) {
    return 1;
  } else {
    return number * factorial(number - 1);
  }
}

// Returns how many trials to run based on autosave settings
int howManySolutionsToDo() {
  if (doEstimateProp) {
    return minSamp;
  }
  if (doAutoFiling) {
    return autoFileQty;
  } else {
    return 1;
  }
}

// Returns formatted time expression preceeded by text argument.
String getTimeNow(String hd) {
  StringBuilder sbTimeNow = new StringBuilder();
  sbTimeNow.append(hd);
  sbTimeNow.append(String.valueOf(year()));
  sbTimeNow.append(".");
  sbTimeNow.append(String.valueOf(nf(month(), 2)));
  sbTimeNow.append(".");
  sbTimeNow.append(String.valueOf(nf(day(), 2)));
  sbTimeNow.append("|");
  sbTimeNow.append(String.valueOf(nf(hour(), 2)));
  sbTimeNow.append(".");
  sbTimeNow.append(String.valueOf(nf(minute(), 2)));
  sbTimeNow.append(".");
  sbTimeNow.append(String.valueOf(nf(second(), 2)));
  return sbTimeNow.toString();
}

void initEstProp() {
  if (doEstimateProp) {
    msfqty = 0;                     // qty of matrices solutions found
    smqty = 0;                      // qty of sampled maatrices
    msnqty = 0;                     // qty of matrices not solutions found
    minfsqty = 5;                   // minimum number of soltions to find
    p = 0;                       // proportion being solution
    p_lowb = 0;                // lowerbound from proportion being solution
    p_upb = 0;                // upperbound from proportion being solution
  }
}
