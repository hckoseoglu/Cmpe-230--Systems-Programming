#include "cell.h"

// Constructor definition
Cell::Cell(int neighborMineCount, bool isMine, bool isFlagged, bool isRevealed, int row, int col)
    : neighborMineCount(neighborMineCount), isMine(isMine), isFlagged(isFlagged), isRevealed(isRevealed), row(row), col(col) {}

// Getter function definitions
int Cell::getNeighborMineCount() {
    return neighborMineCount;
}

bool Cell::getIsMine() {
    return isMine;
}

bool Cell::getIsFlagged() {
    return isFlagged;
}

bool Cell::getIsRevealed() {
    return isRevealed;
}

int Cell::getRow() {
    return row;
}

int Cell::getCol() {
    return col;
}

// Setter function definitions
void Cell::setNeighborMineCount(int count) {
    neighborMineCount = count;
}

void Cell::setIsMine(bool value) {
    isMine = value;
}

void Cell::setIsFlagged(bool value) {
    isFlagged = value;
}

void Cell::setIsRevealed(bool value) {
    isRevealed = value;
}

void Cell::setRow(int x) {
    row = x;
}

void Cell::setCol(int y) {
    col = y;
}
