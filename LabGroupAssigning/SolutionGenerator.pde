// SolutionGenerator //<>//
// Note: The beVerbose sections have been commented out.

// This function is called on a thread.
void DoStartProcess() {
  initializeBestlabGroupMatrix();
  bestunfilledQty = roundsQty * groupQty;
  bestPossibleMin = propBestPossibleMin;
  // start multiple solution trials
  for (int run = 1; run < trialQty + 1; run ++) {
    feedbackStatus(run);
    labGroupMatrix = new LabGroup[roundsQty][groupQty];
    mstrPosGroups = new PossibleGroupsK(classSize, gSize);
    poolSize = mstrPosGroups.pGroups.size();
    row = 0;
    col = 0;
    unfilledQty = 0;
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
          // for this matrix position. Mark as no solution.
          labGroupMatrix[row][col] = noSolLG;
          // Increment no solution counter.
          unfilledQty ++;
        }
        
        //if (beVerbose) {
        //  print(labGroupMatrix[row][col].showMembers());
        //  print(spc(3));
        //}
        
        col ++;
      } // next col
      //reset col index for next row
      col = 0;
      row ++;
      
      //if (beVerbose) {
      //  print("  Remaining labgroups in pool: ", mstrPosGroups.pGroups.size());
      //  println();
      //}
      
    } // next row ie. round

    //if (beVerbose) {
    //  reportResults(unfilledQty);
    //}
    
    // Record any better run.
    recordBetterRunIfAny(run);

    // Break if a perfect solution was found.
    if (bestunfilledQty < bestPossibleMin + 1) { 
      break;
    }
    // Break if a q key was pressed.
    if (quitNow) {
      reportQuitNowMessage(run);
      break;
    }
  } // end run loop
  if (!quitNow) {
    msg = "Done";
    println(msg);
    lastStatusMsg = msg;
  }
  println();
  processIsDone = true;
  setButtonRunState(false);
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

void recordBetterRunIfAny(int run) {
  if (unfilledQty < bestunfilledQty) {
    bestunfilledQty = unfilledQty;
    bestlabGroupMatrix = labGroupMatrix;
    besttrialrun = run;
    msg = "Current best " + bestunfilledQty + " in run # " + besttrialrun;
    println(msg);
  }
}// end recordBetterRunIfAny

void initializeBestlabGroupMatrix() {
  bestlabGroupMatrix = new LabGroup[roundsQty][groupQty];
  for (int r = 0; r < roundsQty; r++) {
    for (int c = 0; c < groupQty; c++) {
      bestlabGroupMatrix[r][c] = noSolLG;
    }
  }
}// end initializeBestlabGroupMatrix

void feedbackStatus(int run) {
  lastStatusMsg = "Least Unfilled: " + bestunfilledQty + " in Trial: " + besttrialrun + "  Current Trial: " + run;
}// end feedbackStatus
