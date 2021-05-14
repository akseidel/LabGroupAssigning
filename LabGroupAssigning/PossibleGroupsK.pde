 //<>// //<>//
class PossibleGroupsK {
  ArrayList<LabGroup> pGroups = new ArrayList();

  PossibleGroupsK(int classSize, int gsize) {
    int N = classSize;
    int R = gsize;
    ArrayList<int[]> selectionsKofN = generateK(N, R);

    for (int[] comb : selectionsKofN) {
      LabGroup grouping = new LabGroup();
      for (int m = 0; m < R; m++) {
        grouping.labglist.append(nf(comb[m], 2));
      }
      pGroups.add(grouping);
    }
  }

  // It is assumed thisLG is in the PossibleGroupsK
  int getIndexOf(LabGroup thisLG) {
    int c = 0;
    int n = thisLG.labglist.size();
    for (int i = 0; i < pGroups.size(); i++) { 
    //  LabGroup lg = pGroups.get(i);
      for (int j = 0; j < n; j++) {
        if (pGroups.get(i).labglist.get(j).equals(thisLG.labglist.get(j))) {
          c++;
        }
        if ( c == n) {
          return i;
        }
      }
    }
    return 0;
  }
  
  
} // end class PossibleGroupsK

private ArrayList<int[]> generateK(int n, int r) {
  ArrayList<int[]> combinations = new ArrayList<int[]>();
  int[] combination = new int[r];
  // initialize with lowest lexicographic combination
  for (int i = 0; i < r; i++) {
    combination[i] = i;
  }
  while (combination[r - 1] < n) {
    combinations.add(combination.clone());
    // generate next combination in lexicographic order
    int t = r - 1;
    while (t != 0 && combination[t] == n - r + t) {
      t--;
    }
    combination[t]++;
    for (int i = t + 1; i < r; i++) {
      combination[i] = combination[i - 1] + 1;
    }
  }
  for (int[] comb : combinations) {
    for (int m = 0; m < r; m++) {
      comb[m]=comb[m]+1;
    }
  }
  return combinations;
}// end generateK
