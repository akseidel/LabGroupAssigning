# Lab Group Assigning

![Example Screen While Running](./readme-images/6x6x4.png)

* A tool for teachers to assign students to lab groups written in Processing's java code **[Processing](processing.org)**. It may be built for running on Apple OSX, Linux and Windows operating systems.
* This tool selects groups of student teams from a student class population to be involved in lab tasks during experiment rounds. Each student is involved once every session round and once for each different tasks.
* Each lab group, i.e. a combination of students as a team, like a student pair for example, is assigned no more than once. The number of possible lab groups, referred to as **Pool Size**, is the number of group sized student combinations chosen from the class size.
* The output results go to both the console and the Processing application screen.
* The inputs are:
  * **Class Size** - The number of students in the selection pool.
  * **Group Qty** - The number of tasks. These are the output matrix columns.
  * **Rounds Qty** - The number of session rounds. These are the output matrix rows.
  * **Group Size** - The student grouping size. The matrix cells are the assigned student groups. The students are selected from the class, i.e. the selection pool. The integer numbers identify the students. For example the student group, "03,06,12", is a group consisting of student 03, student 06 and student 12.
* The **Class Size** should be equal to the **Group Size** x (larger of **Group Qty** and **Rounds Qty**). Student selection will not be a balanced participation when **Group Qty** and **Rounds Qty** are not equal. The same applies when the **Class Size** is larger than the required number. **Chk** value variation indicates unbalanced participation.

## Example Screen - Solution Found

![Example Screen While Running](./readme-images/LabGroupsAssigning-screen-solution.png)

![Example Screen While Running](./readme-images/8x8x2.png)

## Example Screen Output - Keypress Terminated Run

![Example Screen Run](./readme-images/LabGroupsAssigning-screen-terminated.png)

## Notes

* The application window is resizable.
* Execution time is pure luck for the lengthy tasks. For example the solution for the 8 x 8 x 2 shown above occurred under 5 minutes. This same task could take hours.
* The **Chk:** values are row and column checksum values that are the sum of the assigned student id numbers. Properly assigned row and columns will have the same checksum.
* This program continuously makes random lab group selections for each matrix value from an ever decreasing pool of remaining possible lab group candidates. It records the most filled assignment matrix. The displayed matrix is the last best assignment matrix. Selection trials stop when the matrix is totally filled or after the number of solution trials is expired.
* Matrix values like --,--,-- indicate there was no valid lab group combination possible for that matrix position for the trial run.
* The time required to complete the assignment matrix is a function of the selection pool size. The selection pool size depends on the class size (**n**) and the group size (**k**) as **n!/k!\*(n-k)!** . The number of possible assignment matrices of size **gr** (group qty x rounds qty) that can be selected from the pool size **p** is **p!/gr!\*(p-gr)!** . That number can be enormous. 
* The number of valid solution matrices within the pool of possible assignment matrices is not known to this author but the number appears to be large enough to quickly find a valid solution at random from a pool of 3 billion possible for a 5x5 matrix using a 2 group size.
* Pressing the **q** key stops the process and outputs the current best solution. The **Stop** button does the same but it may not be as responsive as the **q** key press.

## File Button

* The **File** button creates a text file of the current results within the folder that contains the application. The file name "LabGroupMatrix" with a time code indicating the time the file is created. For example such a file named LabGroupMatrix.2021-5-17_111583.txt was made at 11:15:03 am on May 17, 2021.
  
![Example Saved File](./readme-images/SavedFileImage.png)

## Install and Running

* Prebuilt application files for OSX, Linux and Windows are not provided in this repository at this time. That may be in the future. They are easily built from the **Processing IDE** with the files in this repository. **LabGroupsAssigning** can be executed from within the **Processing IDE**. Those familiar with **Processing** would need no instructions other than the knowledge that the **G4P** GUI controls library needs to be installed. Those not familiar with **Processing** need to start here: **[Processing](processing.org)**.
* A **Processing** application is a Java application. Therefore the Java runtime system is required to be installed or packaged within the application. As of this writing the option to package Java within the application is possible only with OSX systems.
