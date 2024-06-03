#ifndef MAIN_LAYOUT_H
#define MAIN_LAYOUT_H

#include "cell.h"
#include <QWidget>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <queue>

class MainLayout : public QWidget
{
    Q_OBJECT

public:
    MainLayout(int rows, int cols, std::vector<std::vector<Cell>> *initialMap, int numMines, QWidget *parent = nullptr);
    int getRows();
    int getCols();
    int getScore();
    void setScore(int score);

    // Calculating score
    int calculateNewScore();

    // For cell map
    int getCellNeighbour(int row, int col);
    bool isMineAtCell(int row, int col);
    bool isRevealed(int row, int col);
    bool isFlagged(int row, int col);
    bool isWaitUntilRestart();
    void setRevealed(int row, int col, bool reveal);
    void setFlagged(int row, int col, bool flagegd);
    void setWaitUntilRestart(bool wait);
    bool didWin();
    void revealAllMines();

    // Pop-up functions
    void showWonPopup();
    void showLostPopup();

    // Functions for recursively revealing cells with bft
    void openNeighbors( std::vector<std::vector<Cell>> *grid, int row, int col );
    void bfsHelper( std::vector<std::vector<Cell>> *grid, int row, int col, std::queue<Cell> *myQueue, std::vector<Cell> *visited );
    std::vector<std::vector<Cell>> createMap(int numRows, int numCols, int numOfMines);

    // function for returning image path to the main app
    QIcon getMineIcon();



private:
    int numRows;
    int numCols;

    int score;

    // Win or lose condition
    bool waitUntilRestart;

    // For restaring
    int numMines;

    // For hint
    int hintPressedCount;
    int hintRow;
    int hintCol;

    // Find hint;
    int *giveHint(std::vector<std::vector<Cell>> *grid);


    std::vector<QPixmap> icons;

    enum CellType {
        ZeroCell = 0,
        OneCell = 1,
        TwoCell = 2,
        ThreeCell = 3,
        FourCell = 4,
        FiveCell = 5,
        SixCell = 6,
        SevenCell = 7,
        EightCell = 8,
        EmptyCell = 9,
        FlagCell = 10,
        HintCell = 11,
        MineCell = 12,
    };

    QLabel *scoreLabel;
    QPushButton *hintButton;
    QPushButton *restartButton;
    QGridLayout *gridLayout;

    QHBoxLayout* setupTopLayout();
    QGridLayout* setupBottomLayout(QSize cellSize);

    // For cell map
    std::vector<std::vector<Cell>> *grid;

signals:
    void lost();
    void won();
    void revealedCell(int row, int col);
    void scoreUpdated(int newScore);
    void restart();
    void hint(int row, int col);

private slots:
    void updateScoreLabel(int newScore);
    void restartGame();
};

#endif // MAIN_LAYOUT_H
