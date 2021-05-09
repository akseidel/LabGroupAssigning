// A copy of the mstrPosGroups pool will be used for
void DoStartProcess() {
  initializeBestlabGroupMatrix();
  // start multiple solution trials
  for (int run = 0; run < trialQty; run ++) {
    feedbackStatus(run);
    labGroupMatrix = new LabGroup[roundsQty][groupQty];
    mstrPosGroups = new PossibleGroupsK(classSize, gsize);
    row = 0;
    col = 0;
    unfilledQty = 0;
    // start groups matrix build
    if (beVerbose) {
      printMatrixHeader(true);
    }
    while (row < roundsQty) {
      if (beVerbose) {
        print("Round ", str(row+1), spc(3));
      }   
      while (col < groupQty) {
        MakeFreshTempGroups();
        MakeListOfPriorItemsForThisRowColCell();
        // Purge the tempPosGroups pool of all LabGroups that are not unique with
        // the row and col priors for this row, cell
        PurgeTempPosPoolOfAllNonUniquePriors(priorItemsForThisRowCell, tempPosGroups);      
        // Any LabGroup remaining in the tempPosGroups pool at this point would be a
        // valid pick for this current rol cell. A random LabGroup will be selected.
        // An empty tempPosGroups pool means there is not a solution for this rol cell.
        if (tempPosGroups.pGroups.size() > 0) {
          // There is at least one remaining tempPosGroup.
          // Get index for this valid pick.
          index = int(random(tempPosGroups.pGroups.size()));
          thislg = tempPosGroups.pGroups.get(index);
          // Add the valid labgroup to the matrix
          labGroupMatrix[row][col] = thislg;
          // Get index of the valid LabGroup so it may be removed from the master
          // mstrPosGroups pool.
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
        if (beVerbose) {
          msg = labGroupMatrix[row][col].showMembers();
          print(msg);
          print(spc(3));
        }
        col ++;
      } // next col
      //reset col index for next row
      col = 0;
      row ++;
      if (beVerbose) {
        print("  Remaining labgroups in pool: ", mstrPosGroups.pGroups.size());
        println(spc(3));
      }
    } // next row ie. round

    if (beVerbose) {
      reportResults(unfilledQty);
    }
    // Record any better run.
    recordBetterRunIfAny(run);

    // Break if a perfect solution was found.
    if (bestunfilledQty < 1) { 
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
}// end DoStartProcess

// the trial selections. Each bad trial will be removed 
// from the pool copy. When a selection is valid it will be
// removed from the true mstrPosGroups pool.
void MakeFreshTempGroups() { 
  tempPosGroups = new PossibleGroupsK(classSize, gsize);
}// end MakeFreshTempGroups

// Purge groupsPol of all LabGroups that are not unique to those in priorLabGroups 
void PurgeTempPosPoolOfAllNonUniquePriors(ArrayList<LabGroup> priorLabGroups, PossibleGroupsK groupsPool) {
  for (LabGroup aPriorLG : priorLabGroups) {        
    // Purge must be performed from end to start
    for (int i = groupsPool.pGroups.size()- 1; i >= 0; i--) {
      LabGroup poolLG = groupsPool.pGroups.get(i);
      if (aPriorLG.hasSomeCommon(poolLG)) {
        groupsPool.pGroups.remove(i);
      }
    }
  }
}// end PurgeTempPosPoolOfAllNonUniquePriors

// Make a temporary ArrayList of this matrix rows's
// and col's prior LabGroups solutions.
void  MakeListOfPriorItemsForThisRowColCell() {
  priorItemsForThisRowCell = new ArrayList();
  // pCol is prior columns in this row.
  for (int pCol = 0; pCol < col; pCol = pCol+1) {
    priorItemsForThisRowCell.add(labGroupMatrix[row][pCol] );
  }
  // pRow is prior rows in this column.
  for (int pRow = 0; pRow < row; pRow = pRow+1) {
    priorItemsForThisRowCell.add(labGroupMatrix[pRow][col] );
  }
}// end MakeListOfPriorItemsForThisRowColCell

void recordBetterRunIfAny(int run) {
  if (unfilledQty < bestunfilledQty) {
    bestunfilledQty = unfilledQty;
    bestlabGroupMatrix = labGroupMatrix;
    besttrialrun = run + 1;
    msg = "Current best " + bestunfilledQty + " in run # " + besttrialrun;
    println(msg);
  }
}// end recordBetterRunIfAny

void initializeBestlabGroupMatrix(){
  bestlabGroupMatrix = new LabGroup[roundsQty][groupQty];
  for (int r = 0 ; r < roundsQty; r++){
    for(int c = 0 ; c < groupQty; c++){
      bestlabGroupMatrix[r][c] = noSolLG;
    }
  }
}// end initializeBestlabGroupMatrix

void feedbackStatus(int run){
  lastStatusMsg = "Least Unfilled: " + bestunfilledQty + " in Trial: " + besttrialrun + "  Current Trial: " + run;
}// end feedbackStatus
