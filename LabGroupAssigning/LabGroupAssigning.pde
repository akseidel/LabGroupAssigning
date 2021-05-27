import g4p_controls.*;  // Install this library. It provides the GUI controls.

// LabGroupAssigning   5/2021 AKS
// Selects from a student class size student teams to be involved in lab tasks
// during experiment rounds. Each student is involved once every session round
// and once for each different tasks. No one student lab grouping is involved
// more than once.
//
// Output goes to both the console and the Processing application screen but the
// process is blocking to the Processing screen. Therefore the process is run in 
// a thread, which signals when there are updates for the screen draw to display.
// 
// Pressing the q key stops the process and outputs the current best solution.
//
int trialQty = 100000000;         // Number of trial runs.
//boolean beVerbose = true;   // Display each trial in the console, sections are commented out.
boolean beVerbose = false;    // Do not sisplay each trial in the console.
boolean quitNow = false;      // used for quitting a long process with a q keypress.
boolean thereIsANewBest = false;
boolean doAutoFiling = false;

int classSize = 18;         // The number of students in the class
int gSize = 3;              // Number of students in each group
int groupQty = 6;           // Number of groups during each event time session
int roundsQty = 6;          // Number of event time sessions
int poolSize;                 // Number of gSize combinations in classSize 
int besttrialrun = 1;         // Trial number where best run first occurred.
int bestunfilledQty = roundsQty * groupQty;
int propBestPossibleMin = besttrialrun; 
int bestPossibleMin = 0;      // Best possible solution has this remaining unfilles slections. 
int row ;
int col ;
int index;                    // thislg index usually
int unfilledQty;
int milliStart;
int milliEnd;
int autoFileQty = 1;
boolean isMsgFeedBack = false;
boolean processIsDone = false;
boolean stopConsoleOutput = false;
String theWarning = new String();
StringList warningsList = new StringList();
StringList historyList = new StringList();

LabGroup[][] bestlabGroupMatrix;
LabGroup noSolLG = defNoSolLG(gSize);
PossibleGroupsK tempPosGroups;                // temporary possiblegroups pool copy
ArrayList<LabGroup> priorItemsForThisRowCell; // Used for the trial comparisons.
LabGroup[][] labGroupMatrix ;                 // The result matrix
PossibleGroupsK mstrPosGroups;                // collection of all possible groups
LabGroup thislg ;                             // Labgroup selection under question

// display related
PFont f;
String msg;
String lastStatusMsg = new String();
int fontsize = 12;
int vfontgap = 6;
int drawborder = 16;
int currentlineY = drawborder + fontsize;

void setup() {
  size(980, 600);
  background(200);
  createGUI();
  initGUI();
  initDisplays();
  thread("DoStartProcess");
}

void draw() {
  background(200);
  currentlineY = drawborder + fontsize;
  if (warningsList.size() > 0) {
    outputWarnings();
  }
  showInitialHeader(false);
  nextLineY();
  text(lastStatusMsg, drawborder, nextLineY());

  if (processIsDone || quitNow) {
    // This section runs when process is done or quitted.
    printFirstBest(stopConsoleOutput);
    printBestResultsMatrix(stopConsoleOutput);
    reportLeftOverGroups(stopConsoleOutput, 0);
    // Allows summary to print only once at the console.
    stopConsoleOutput = true;
  } else {
    // This section executes when the process thread is active.  
    printBestResultsMatrix(true);
  }
  checkForUserWindowResize();
} // end draw

void keyPressed() {   
  if (key == 'q' || key == 'Q') {
    setButtonRunEnableState(false);
    quitNow = true;
  }
}
