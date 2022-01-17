import g4p_controls.*;  // Install this library. It provides the GUI controls.

// LabGroupAssigning   5/2021 AKS, 1/2022 AKS
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
int trialMaxQty = 1000000000;        // Number of trial runs.
//boolean beVerbose = true;   // Display each trial in the console, sections are commented out.
boolean beVerbose = false;           // Do not sisplay each trial in the console.
boolean processWasQuit = false;      // used for quitting a long process with a q keypress.
boolean thereIsANewBest = false;
boolean doAutoFiling = false;
boolean doUnused = false;
boolean modeRuthless = false;        // Abandon matrix trials at first failed matrix position

int classSize = 16;           // The number of students in the class
int gSize = 2;                // Number of students in each group
int groupQty = 8;             // Number of groups during each event time session
int roundsQty = 8;            // Number of event time sessions
int poolSize;                 // Number of gSize combinations in classSize
int besttrialrun = 1;         // Trial number where best run first occurred.
int bestunfilledQty = roundsQty * groupQty;
int projBestPossibleMin = besttrialrun;   // projected best possible fill for unbalanced conditions
int bestPossibleMin = 1;      // Best possible solution has this remaining unfilled selections minus 1.
int row ;
int col ;
int index;                    // thislg index usually
int unfilledQty;
int milliTStart;              // single trial start
int milliTEnd;                // single trial end
int milliSStart;              // session start
int milliSEnd;                // session end
int autoFileQty = 1;
boolean isMsgFeedBack = false;
boolean processCompleted = true; // false suppresses finished status at initial startup
boolean noConsoleOutput = false;
String theWarning = new String();
StringList warningsList = new StringList();
StringList bestHistList = new StringList();
String propEstimate;
String timeSolStart = new String();
String timeSolEnd = new String();
String timeSStart = new String();
String timeSEnd = new String();

// proportion Estimate related
boolean doEstimateProp = false;   // Estimate the solutions proportion
int msfqty;                       // qty of matrices solutions found
int smqty;                        // qty of sampled maatrices
int msnqty;                       // qty of matrices not solutions found
int minfsqty;                     // minimum number of soltions to find
float p;                          // proportion being solution
float p_lowb;                   // lowerbound from proportion being solution
float p_upb;                   // upperbound from proportion being solution
int minSamp = 10;                 // minimum samples for proportion estimate (5)
int minSampAbs = 5;

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
String remGpSep = "|";
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
  setProcessInits();
  thread("DoStartProcess");
}

void draw() {
  background(200);
  currentlineY = drawborder + fontsize;
  if (warningsList.size() > 0) {
    outputWarnings();
  }
  showSummaryText(false);
  nextLineY();
  text(lastStatusMsg, drawborder, nextLineY());

  // Output strategy here divides into two modes.
  // One is for output while process is running. The other is for output
  // when process is complete. Output goes to app window and the console.
  // The draw loop runs continously. Output to the console needs to stop
  // when the process is not running.
  if (processCompleted || processWasQuit) {
    // This if section runs when process is completed or quitted.
    if (!modeRuthless) {
      printRptFirstBest(noConsoleOutput);
     }
    printBestResultsMatrix(noConsoleOutput);
    if (doUnused) {
      reportLeftOverGroups(noConsoleOutput, 0);
    }
    // Causes summary to print only once at the console.
    noConsoleOutput = true;
  } else {
    // This section executes when the process thread is active.
    printBestResultsMatrix(true);
  }
  checkForUserWindowResize();
} // end draw

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    setButtonRunEnableState(false);
    processWasQuit = true;
  }
}
