#include <QApplication>
#include "main_layout.h"
#include "cell.h"
#include <iostream>
#include <vector>
#include <cstdlib> // For rand() and srand()
#include <ctime>   // For time()

/*
 *  CONFIG PARAMETERS
 */

int const NUM_ROWS = 20;
int const NUM_COLS = 20;
int const NUM_MINES = 20;

/*
 *  END OF CONFIG PARAMETERS
 */


// declaring the functions
std::vector<std::vector<Cell>> createMap( int numRows, int numCols, int numOfMines );
void printMapIsMine( std::vector<std::vector<Cell>> grid, int numRows, int numCols );
void printMapNeighbors( std::vector<std::vector<Cell>> grid, int numRows, int numCols );

int main(int argc, char **argv)
{
    std::vector<std::vector<Cell>> grid = createMap(NUM_ROWS, NUM_COLS, NUM_MINES);
    printMapIsMine(grid, NUM_ROWS, NUM_COLS);
    printMapNeighbors(grid, NUM_ROWS, NUM_COLS);

    QApplication app (argc, argv);

    MainLayout mainLayout(NUM_ROWS, NUM_COLS, &grid, NUM_MINES);
    mainLayout.show();

    // Set game name and icon
    mainLayout.setWindowTitle(QString("minesweeper"));
    //QIcon icon(mainLayout.getMineIcon());
    QIcon icon(mainLayout.getMineIcon());
    mainLayout.setWindowIcon(icon);
    app.setWindowIcon(icon);
    return app.exec();
}


std::vector<std::vector<Cell>> createMap( int numRows, int numCols, int numOfMines){
    // Seed the random number generator
    srand(static_cast<unsigned int>(time(nullptr)));

    // Create a 2D vector of Cell objects and initialize each cell
    std::vector<std::vector<Cell>> grid(numRows, std::vector<Cell>(numCols));

    // Initialize each cell in the grid
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            // Initialize each cell with default constructor
            grid[i][j] = Cell(0, false, false, false, i, j);
        }
    }

    // Set random numOfMines coordinates to be mine
    for (int minesPlaced = 0; minesPlaced < numOfMines;) {
        int randRow = rand() % numRows;
        int randCol = rand() % numCols;

        // Check if the cell is already a mine
        if (!grid[randRow][randCol].getIsMine()) {
            grid[randRow][randCol].setIsMine(true);
            ++minesPlaced;
        }
    }

    // Set number of neighbor mines for each cell
    for(int currentRow = 0; currentRow < numRows; currentRow++){
        for(int currentCol = 0; currentCol < numCols; currentCol++){
            int tempNumOfMines = 0;
            for(int rowAdd = -1; rowAdd < 2; rowAdd++){
                for(int colAdd = -1; colAdd < 2; colAdd++){
                    if(colAdd == 0 && rowAdd == 0) continue;
                    int neighborRow = currentRow + rowAdd;
                    int neighborCol = currentCol + colAdd;
                    if (neighborRow < 0 || neighborCol < 0 || neighborRow >= numRows || neighborCol >= numCols) continue;
                    if(grid[neighborRow][neighborCol].getIsMine()){
                        tempNumOfMines++;
                    }
                }
            }
            grid[currentRow][currentCol].setNeighborMineCount(tempNumOfMines);
        }
    }
    return grid;
}

void printMapIsMine( std::vector<std::vector<Cell>> grid, int numRows, int numCols ){
    // Print the grid
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            std::cout << (grid[i][j].getIsMine() ? "*" : "-") << " ";
        }
        std::cout << std::endl;
    }
}

void printMapNeighbors( std::vector<std::vector<Cell>> grid, int numRows, int numCols ){
    // Print the numbers
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            std::cout << (grid[i][j].getNeighborMineCount())<< " ";
        }
        std::cout << std::endl;
    }
}
