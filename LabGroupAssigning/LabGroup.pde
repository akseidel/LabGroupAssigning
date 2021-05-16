// Meant to be a lab group of students working together
// where students are string ids

class LabGroup {
  StringList labglist;
  LabGroup( StringList glist) {
    labglist = glist;
    //labglist.sort();
  }
  LabGroup( ) {
    labglist = new StringList();
  }

  String showMembers() {
    return join(labglist.array(), ",");
  }

  int sumMembers() {
    int sum = 0;
    for (String lgItem : labglist) {
      sum = sum + int(lgItem);
    }
    return sum;
  }

  // Compares a LabGroup to this LabGroup.
  // Returns true if any one item is common to both LabGroups
  boolean hasSomeCommon( LabGroup anLG) {
    for (String lgitem : anLG.labglist) {
      if (labglist.hasValue(lgitem)) { 
        return true;
      }
    }
    return false;
  }
} // end LabGroup

// Assembles the no solution LabGroup
LabGroup defNoSolLG(int gsize) {
  LabGroup LG = new LabGroup();
  while (LG.labglist.size() < gsize) {
    LG.labglist.append("--");
  }
  return LG;
}
