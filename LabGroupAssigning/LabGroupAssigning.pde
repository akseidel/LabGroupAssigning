import g4p_controls.*; //<>//

// LabGroupAssigning   5/2021 AKS
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

int classSize = 16;           // The number of students in the class
int gSize = 2;                // Number of students in each group
int groupQty = 8;             // Number of groups during each event time session
int roundsQty = 8;            // Number of event time sessions
long poolSize;                // Number of gSize combinations in classSize 
int besttrialrun = 1;         // Trial number where best run first occurred.
int bestunfilledQty = roundsQty * groupQty;
int row ;
int col ;
int index;                    // thislg index usually
int unfilledQty;
boolean isMsgFeedBack = false;
boolean processIsDone = false;
boolean stopConsoleOutput = false;

LabGroup[][] bestlabGroupMatrix;
LabGroup noSolLG = defNoSolLG(gSize);
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
  createGUI();
  initGUI();
  size(1000, 600);
  fontSetUp();
  background(200);
  setPoolSize();
  showInitialHeader(true);
  thread("DoStartProcess");
}

void draw() {
  background(200);
  currentlineY = drawborder + fontsize;
  showInitialHeader(false);
  nextlineY();
  text(lastStatusMsg, drawborder, nextlineY());

  if (processIsDone || quitNow) {
    // This section runs when process is done or quitted.
    printFirstBest(stopConsoleOutput);
    printBestResultsMatrix(stopConsoleOutput);
    // Allows summary to print only once at the console.
    stopConsoleOutput = true;
  } else {
    // This section executes when the process thread is active.  
    printBestResultsMatrix(true);
  }
} // end draw

void keyPressed() {   
  if (key == 'q' || key == 'Q') {     
    quitNow = true;
  }
}
