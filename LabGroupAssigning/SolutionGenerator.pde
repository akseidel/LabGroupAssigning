// SolutionGenerator //<>// //<>//
// Note: The beVerbose sections have been commented out.

int cntSolution;
int trialRun;

// This function is called on a thread.
void DoStartProcess() {
  boolean doTerminateTrial;
  milliSStart = millis();
  timeSStart = getTimeNow("Session Start: ");
  timeSEnd = " - |";
  // Looping through number of solutions to find for either filing solution purpose
  // or for estimating a solution proportion.
  for (cntSolution = 1; cntSolution <  howManySolutionsToDo() + 1; cntSolution++) {
    putStatusOnTitle();
    timeSolStart = getTimeNow("Trial Start: ");
    timeSolEnd = " - |";
    milliTStart = millis();
    bestunfilledQty = roundsQty * groupQty;
    bestPossibleMin = propBestPossibleMin;
    historyList.clear();

    // Looping through trials to discover a solution.
    for (trialRun = 1; trialRun < trialMaxQty + 1; trialRun ++) {
      feedbackStatus(trialRun);
      labGroupMatrix = new LabGroup[roundsQty][groupQty];
      mstrPosGroups = new PossibleGroupsK(classSize, gSize);

      poolSize = mstrPosGroups.pGroups.size();
      row = 0;
      col = 0;
      unfilledQty = 0;
      doTerminateTrial = false;
      // start groups matrix build

      //if (beVerbose) {
      //  printMatrixHeader(beVerbose);
      //}

      // The start for each trial.
      // The mstrPosGroups is the master possible groups collection. This is a
      // collection of all the possible selection combinations. During each trial
      // each selection determined to be valid at the time is added to the assigning
      // matrix and then removed from the mstrPosGroups. Thus that selection cannot
      // be selected again. But for each element selection the prior students selected
      // for any one element's row and column cannot be slected again because each row,
      // or round as it is called, and each column, or group as it is called, are not to
      // have a single student occur more than once. A copy of the mstrPosGroups collection,
      // called the tempPosGroups, is used as the selection pool for any one cell selection
      // after the appropriet student containing prior selections for that row and colum
      // are first removed from the copy of the mstrPosGroups selection matrix.

      while (row < roundsQty) {

        //if (beVerbose) {
        //  print("Round ", str(row+1), spc(3));
        //}

        while (col < groupQty) {
          // Make a fresh copy of the current mstrPosGroups selection pool. This
          // copy is the tempPosGroups pool. The appropriet prior lab groups will
          // be removed from the tempPosGroups before a random selection is drawn
          // from it.
          MakeFreshTempGroups();

          // Collect all the prior selections in the same row and same column as the
          // current row, col. This collection is called priorItemsForThisRowCell.
          // This collection will be used for removing all possible selections
          // in the temporary pool that contain the students present in the prior
          // items collection.
          MakeListOfPriorItemsForThisRowColCell(row, col);

          // Purge the tempPosGroups pool of all LabGroups that are not unique with
          // the row and col priors for this row, cell. After this step any selection
          // from the tempPosGroups pool will have students new to both the current
          // round (row) and group (column) for this row/column matrix cell.
          PurgeTempPosPoolOfAllNonUniquePriors(priorItemsForThisRowCell, tempPosGroups);

          // Any LabGroup remaining in the tempPosGroups pool at this point would be a
          // valid pick for this current row cell. A random LabGroup will be selected.
          // An empty tempPosGroups pool means there is not a solution for this row cell.
          // An empty mstrPosGroups pool means there no solutions anymore.
          if ( (tempPosGroups.pGroups.size() > 0) && (mstrPosGroups.pGroups.size() > 0) ) {
            // There is at least one remaining tempPosGroup.
            // Get index for this valid pick.
            index = int(random(tempPosGroups.pGroups.size()));
            thislg = tempPosGroups.pGroups.get(index);
            // Add the valid labgroup to the matrix
            labGroupMatrix[row][col] = thislg;
            // Get index of the valid LabGroup so it may be removed from the master pool
            // mstrPosGroups.
            index = mstrPosGroups.getIndexOf(thislg);
            // Remove the labgroup from the pool
            mstrPosGroups.pGroups.remove(index);
          } else {
            // tempPosGroups pool is exhausted, there are no solutions
            // for this matrix position.qq
            // Increment no solution counter.
            unfilledQty ++;
            // Mark as no solution.
            labGroupMatrix[row][col] = noSolLG;
            // Terminating the trial in modeRuthless results in much faster operation
            // at the expense of seeing the bestunfilled matrix guesses. The more members
            // there are in the labgroups, the faster the operation.
            if (modeRuthless) {
              // set doTerminateTrial flag
              doTerminateTrial = true;
              break;// breaks out of for while col loop
            }
            // Terminate check. There is no point to continue with this trial if the
            // unfilledQty equals the current best.
            if (bestunfilledQty <= unfilledQty) {
              // set doTerminateTrial flag
              doTerminateTrial = true;
              break;// breaks out of for while col loop
              // intent is to also cascade out of the while row loop and thus this trial
            }
            // Yes,all trials could be abandoned at the first dud. Doing so would speed the
            // process considerably as lab group member size increases.
          }

          //if (beVerbose) {
          //  print(labGroupMatrix[row][col].showMembers());
          //  print(spc(3));
          //}

          col ++;
        } // end while next col

        // Cascade break out of this trial trialRun if doTerminateTrial flag is set.
        if (doTerminateTrial) {
          break;// breaks out of for while row loop, ie break from the trial trialRun
          // because it cannot be a solution
        }

        //reset col index for next row
        col = 0;
        row ++;

        //if (beVerbose) {
        //  print("  Remaining labgroups in pool: ", mstrPosGroups.pGroups.size());
        //  println();
        //}
      } // end while next row ie.round
      // ************    The trial trialRun is over at this point.
      // Matrix is either not populated, ie a dud, or populated, ie a solution
      // at this point, but not yet as to categorized which.

      //if (beVerbose) {
      //  reportResults(unfilledQty);
      //}

      // Break if a q key was pressed.
      if (processWasQuit) {
        milliTEnd = millis();
        milliSEnd = milliTEnd;
        reportQuitNowMessage(trialRun);
        endMsgWindowTitle( "Terminated", cntSolution, autoFileQty);
        break; // breaks out of for trialRun loop
        // intent is to cascade break from all matrix guess trials
      }

      // Record any better trialRun.
      recordBetterRunIfAny(trialRun);

      // Break if a perfect solution was found.
      if (bestunfilledQty < bestPossibleMin + 1) {
        milliTEnd = millis();
        endMsgWindowTitle( "Completed", cntSolution, autoFileQty);
        break; // breaks out of for trialRun loop, ie from all matrix guess trials
      }
    } // end for trialRun loop, ie the matrix guess trial
    // Matrix is now categorized not populated, ie a dud, or populated, ie a solution

    timeSolEnd = getTimeNow(" - Trial End: ");

    if (processWasQuit) {
      break; // breaks out of for cntSolution,the repeating loop to find multiple solutions
    } else {
      msg = "This last matrix find completed in " + timeElapsed(milliTStart, milliTEnd);
      println(msg);
      lastStatusMsg = msg;
    }
    println();

    if (!doEstimateProp) {
      processCompleted = true;
    } else {
      if (msfqty >= minSamp) {
        processCompleted = true;
      }
    }

    if (doAutoFiling) {
      filePrint("Auto-saved");
    }
  }// end for cntSolution, the repeating loop to find multiple solutions

  setButtonRunEnableState(false);
  milliSEnd = millis();
  timeSEnd = " - Duration: " + timeElapsed(milliSStart, milliSEnd);
}// end DoStartProcess

// The valid trial selections. Each bad trial will be removed
// from the pool copy. When a selection is valid it will be
// removed from the true mstrPosGroups pool. The tempPosGroups
// is a copy of the ever decreasing m.strPosGroups pool
void MakeFreshTempGroups() {
  tempPosGroups = new PossibleGroupsK(mstrPosGroups.pGroups);
}// end MakeFreshTempGroups

// Purge groupsPol of all LabGroups that are not unique to those in priorLabGroups
void PurgeTempPosPoolOfAllNonUniquePriors(ArrayList<LabGroup> priorLabGroups, PossibleGroupsK tempGroupsPool) {
  for (LabGroup aPriorLG : priorLabGroups) {
    // Purge must be performed from end to start
    for (int i = tempGroupsPool.pGroups.size()- 1; i >= 0; i--) {
      LabGroup poolLG = tempGroupsPool.pGroups.get(i);
      if (aPriorLG.hasSomeCommon(poolLG)) {
        tempGroupsPool.pGroups.remove(i);
      }
    }
  }
}// end PurgeTempPosPoolOfAllNonUniquePriors

// Make a temporary ArrayList of this matrix rows's
// and col's prior LabGroups solutions.
void  MakeListOfPriorItemsForThisRowColCell(int row, int col) {
  priorItemsForThisRowCell = new ArrayList();
  LabGroup pI;
  // pCol is prior columns in this row.
  for (int pCol = 0; pCol < col+1; pCol = pCol+1) {
    pI = labGroupMatrix[row][pCol];
    if ((pI != noSolLG) & (pI != null)) {
      priorItemsForThisRowCell.add(labGroupMatrix[row][pCol] );
    }
  }
  // pRow is prior rows in this column.
  for (int pRow = 0; pRow < row + 1; pRow = pRow+1) {
    pI = labGroupMatrix[pRow][col];
    if ((pI != noSolLG) & (pI != null)) {
      priorItemsForThisRowCell.add(labGroupMatrix[pRow][col] );
    }
  }
}// end MakeListOfPriorItemsForThisRowColCell

void recordBetterRunIfAny(int trialRun) {
  // todo - refactor for modeRuthless
  if (unfilledQty < bestunfilledQty) {
    StringBuilder sbMsg = new StringBuilder();
    StringBuilder sbMsgHist = new StringBuilder();
    bestunfilledQty = unfilledQty;
    bestlabGroupMatrix = labGroupMatrix;
    besttrialrun = trialRun;
    sbMsg.append("Current best ");
    sbMsg.append( bestunfilledQty);
    sbMsg.append(" in trial ");
    sbMsg.append( nfc(besttrialrun));
    sbMsg.append(" at time ");
    sbMsg.append(timeElapsed(milliTStart, millis()));
    // output just for console
    println(sbMsg.toString());
    // The history string is slightly different.
    sbMsgHist.append(bestunfilledQty);
    sbMsgHist.append(" remaining, trial: ");
    sbMsgHist.append(nfc(besttrialrun));
    sbMsgHist.append(" , at ");
    sbMsgHist.append(timeElapsed(milliTStart, millis()));
    historyList.append(sbMsgHist.toString());
    // proportion estimate figures if a solution
    if ((bestunfilledQty < bestPossibleMin + 1) & (doEstimateProp)) {
      msfqty = msfqty + 1;
      smqty = smqty + trialRun;
      msnqty = msnqty + trialRun - 1;
      // Make proportion estimate if enough solutions sampled
      doEstimatePropIntoHistory();
    } // end if doEstimateProp
  } // end if it is a better trialRun
}// end recordBetterRunIfAny

// Make proportion estimate if enough solutions sampled
void doEstimatePropIntoHistory() {
  String estProp = strEstimateProportion();
  historyList.append(estProp);
  // output just for console
  println(estProp);
} // end doEstimatePropIntoHistory

// Make proportion estimate if enough solutions sampled
String strEstimateProportion() {
  StringBuilder sbMsgEst = new StringBuilder();
  if (msfqty >= minSampAbs) {
    p = float(msfqty)/float(smqty);
    p_upb = p + 1.96 * sqrt(p * (1.0-p)/ float(smqty));
    p_lowb = p - 1.96 * sqrt(p * (1.0-p)/ float(smqty));
    sbMsgEst.append( nfc(msfqty));
    sbMsgEst.append(" solutions found in ");
    sbMsgEst.append( nfc(smqty));
    sbMsgEst.append(" samples");
    sbMsgEst.append(",95% confidence p_low: ");
    sbMsgEst.append( p_lowb);
    sbMsgEst.append(" ,p: ");
    sbMsgEst.append( p);
    sbMsgEst.append(" ,p_up: ");
    sbMsgEst.append( p_upb);
  } else {
    sbMsgEst.append( msfqty);
    sbMsgEst.append(" solutions sampled is not enough for a proportion estimate.");
  }// end if meets minimum samples found
  return sbMsgEst.toString();
} // end strEstimateProportion()


// Creates a new matrix populated with noSolLG
// This must be called outside of the process thread. At one time it
// was called within the process thread. Sometimes the draw loop
// would catch the matrix as it was being created when parts were
// still null.
void initializeBestlabGroupMatrix() {
  bestlabGroupMatrix = new LabGroup[roundsQty][groupQty];
  for (int r = 0; r < roundsQty; r++) {
    for (int c = 0; c < groupQty; c++) {
      bestlabGroupMatrix[r][c] = noSolLG;
    }
  }
}// end initializeBestlabGroupMatrix

//// Restores, ie populates existing matrix with noSolLG
//// Using this inside of the process thread seems to prevent the
//// condition where the draw loop would find parts of the matrix
//// null during trial switching.
//void emptyTheBestlabGroupMatrix(LabGroup[][] bestlabGroupMatrix) {
//  for (int r = 0; r < roundsQty; r++) {
//    for (int c = 0; c < groupQty; c++) {
//      bestlabGroupMatrix[r][c] = noSolLG;
//    }
//  }
//}// end emptyTheBestlabGroupMatrix

void feedbackStatus(int trialRun) {
  StringBuilder sbMsg = new StringBuilder();
  if (!modeRuthless) {
    sbMsg.append("Least Unfilled: ");
    sbMsg.append( bestunfilledQty);
    sbMsg.append(" in trial ");
    sbMsg.append( nfc(besttrialrun));
    sbMsg.append("  ");
  }
  sbMsg.append("Current Trial: ");
  sbMsg.append(nfc(trialRun));
  lastStatusMsg = sbMsg.toString();
}// end feedbackStatus


void putStatusOnTitle() {
  StringBuilder sbTitle = new StringBuilder();
  sbTitle.setLength(0);
  sbTitle.append(windowTitle);
  if (doAutoFiling) {
    sbTitle.append(" | Running ... Will auto-save this ");
    sbTitle.append(cntSolution);
    sbTitle.append(" of ");
    sbTitle.append(autoFileQty);
  } else {
    if ( doEstimateProp) {
      sbTitle.append(" | Sampling for " + cntSolution + " of " + minSamp + " solutions");
    } else {
      sbTitle.append(" | Running ...");
    }
  }
  surface.setTitle(sbTitle.toString());
}


void endMsgWindowTitle( String reason, int cntSolution, int autoFileQty) {
  if (doAutoFiling) {
    surface.setTitle(windowTitle + " | " + reason + ", this auto-save " + cntSolution + " of " + autoFileQty);
  } else {
    surface.setTitle(windowTitle + " | " + reason);
  }
}
