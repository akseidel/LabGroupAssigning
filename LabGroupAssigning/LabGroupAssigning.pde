// LabGroupAssigning   5/2021 AKS //<>//
// Selects from a student class size student teams to be involved in lab tasks
// during experiment rounds. Each student is involved once every session round
// and once for each different tasks.
//
// Output goes to both the console and the Processing application screen but the
// process is blocking to the Processing screen and therefore output shows to the
// Processing screen only before the procrss starts and after the process is done.
// Pressing the q key stops the process and outputs the current best solution.
//
int trialQty = 1000000;         // Number of trial runs.
//boolean beVerbose = true;   // Display each trial in the console
boolean beVerbose = false;    // Do not sisplay each trial in the console.
boolean quitNow = false;      // used for quitting a long process with a q keypress.
boolean thereIsANewBest = false;

int classSize = 24;           // The number of students in the class
int roundsQty = 8;            // Number of event time sessions
int groupQty = 8;             // Number of groups during each event time session
int gsize = 3;                // Number of students in each group
int besttrialrun = 0;         // Trial number where best run first occurred.
int bestunfilledQty = roundsQty * groupQty;
int row ;
int col ;
int index;                    // thislg index usually
int unfilledQty;
String colgap =  "   ";
boolean isMsgFeedBack = false;
boolean processIsDone = false;

LabGroup[][] bestlabGroupMatrix = new LabGroup[roundsQty][groupQty];
LabGroup noSolLG = defNoSolLG(gsize);
PossibleGroupsK tempPosGroups; // temporary possiblegroups pool copy
ArrayList<LabGroup> priorItemsForThisRowCell; // Used for the trial comparisons.
LabGroup[][] labGroupMatrix ; // The result matrix
PossibleGroupsK mstrPosGroups; // collection of all possible groups
LabGroup thislg ;             // Labgroup selection under question

// display related
PFont f;
String msg;
String lastStatusMsg = new String();
int fontsize = 12;
int vfontgap = 6;
int drawborder = 16;
int currentlineY = drawborder + fontsize;

void setup() {
  size(1000, 600);
  fontSetUp();
  background(200);
  showInitialHeader(true);
  //noLoop();
  thread("DoStartProcess");
}

void draw() {
  background(200);
  currentlineY = drawborder + fontsize;
  showInitialHeader(false);
  nextlineY();
  text(lastStatusMsg, drawborder, nextlineY());

  if (processIsDone) {
    noLoop();
    msg ="First best number of unfilled groups in "+ trialQty+ " runs. "+ bestunfilledQty+ " unfilled in Run #:"+ besttrialrun ;
    println(msg);
    nextlineY();
    text(msg, drawborder, nextlineY());
    printMatrixHeader(false);
    printBestResultsMatrix(false);
  } else {
    printMatrixHeader(true);
    printBestResultsMatrix(true);
  }
} // end draw


void keyPressed() {   
  if (key == 'q' || key == 'Q') {     
    quitNow = true;
  }
}
