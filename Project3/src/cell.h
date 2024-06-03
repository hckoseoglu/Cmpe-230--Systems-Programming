#ifndef CELL_H
#define CELL_H

class Cell {
private:
    int neighborMineCount;
    bool isMine;
    bool isFlagged;
    bool isRevealed;
    int row;
    int col;

public:
    // Constructor
    Cell(int neighborMineCount = 0, bool isMine = false, bool isFlagged = false, bool isRevealed = false, int row = 0, int col = 0);

    // Getter functions
    int getNeighborMineCount();
    bool getIsMine();
    bool getIsFlagged();
    bool getIsRevealed();
    int getRow();
    int getCol();

    // Setter functions
    void setNeighborMineCount(int count);
    void setIsMine(bool value);
    void setIsFlagged(bool value);
    void setIsRevealed(bool value);
    void setRow(int x);
    void setCol(int y);
};


#endif // CELL_H
