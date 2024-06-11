#include "main_layout.h"
#include "cellbutton.h"
#include <QIcon>
#include <QMessageBox>
#include <queue>

// base path
const QString BASE_IMAGE_PATH = "/Users/hikmetcankoseoglu/Qt/Projects/mine_sweeper/assets/";
// Cell Scaling Factor
const int CELL_SCALE = 2;
// any cell asset
const QString SAMPLE_IMG = "0.png";
// mine icon asset
const QString MINE_IMG = "12.png";

void printMapNeighbors( std::vector<std::vector<Cell>> grid, int numRows, int numCols );

MainLayout::MainLayout(int rows, int cols, std::vector<std::vector<Cell>> *initialMap,int mineCount, QWidget *parent)
    : QWidget(parent), numRows(rows), numCols(cols), grid(initialMap)
{
    // Init varianles
    hintRow = -1;
    hintCol = -1;
    setScore(0);
    waitUntilRestart = false;
    numMines = mineCount;
    // Main layout
    QVBoxLayout *mainLayout = new QVBoxLayout; // Create a main vertical layout
    // Set cell and icon size
    QSize cellSize = QPixmap(BASE_IMAGE_PATH + SAMPLE_IMG).size() * CELL_SCALE;
    QSize iconSize = cellSize * 1;

    // Initialize icons vector
    for (int i = 0; i <= 12; ++i) {
        QPixmap pixmap(BASE_IMAGE_PATH + QString::number(i) + ".png");
        QPixmap scaled = pixmap.scaled(iconSize);
        icons.push_back(scaled);
    }

    // Instantiate toplayout
    QHBoxLayout *topLayout = setupTopLayout();
    mainLayout->addLayout(topLayout); // Add the top layout to the main layout
    mainLayout->addLayout(setupBottomLayout(cellSize)); // Add the bottom layout to the main layout

    setLayout(mainLayout); // Set the main layout as the layout of the MainLayout widget
    // Calculate the fixed size based on button size and number of rows/columns
    // Increase vertical spacing inversly proportional to the number of rows
    float verticalScaling = 1 + (2.0 / numRows); // f = a + b/x a =1, b = 2
    float horizontalScaling = 1.05 + (1.0 / numCols); // f = a + b/x a = 1.05, b = 1
    float width = (numCols * cellSize.width()) * horizontalScaling;
    float height = (numRows * cellSize.height()) * verticalScaling + topLayout->sizeHint().height(); // Add height of top layout
    setFixedSize(width, height); // Set fixed size of the main layout
}

QHBoxLayout* MainLayout::setupTopLayout()
{
    QHBoxLayout *topLayout = new QHBoxLayout;
    // Score Label
    scoreLabel = new QLabel("Score: 0");
    scoreLabel->setAlignment(Qt::AlignLeft | Qt::AlignVCenter);

    // Stretch to add space between score label and buttons
    topLayout->addWidget(scoreLabel);

    // Add a stretch
    topLayout->addStretch();

    // Hint Button
    hintButton = new QPushButton("Hint");
    hintButton->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    connect(hintButton, &QPushButton::clicked, this, [=](){
        if (!isWaitUntilRestart()) {
            if (hintPressedCount == 0) {
                // reveal if all
                // call hint function
                int* hintCors = giveHint(grid);
                if (hintCors != NULL) {
                    hintRow = hintCors[0];
                    hintCol = hintCors[1];
                    delete[] hintCors;

                    hintPressedCount = 1;
                    emit hint(hintRow, hintCol);
                }
            } else {
                // Reveal the cell att hintRow and hintCol
                hintPressedCount = 0;
                openNeighbors(grid, hintRow, hintCol);
                hintRow = -1;
                hintCol = -1;
            }
        }
    });


    // Restart Button
    restartButton = new QPushButton("Restart");
    // Set button action
    connect(restartButton, &QPushButton::clicked, this, &MainLayout::restartGame);
    restartButton->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    const int buttonWidth = 100; // Adjust this value as needed

    hintButton->setFixedWidth(buttonWidth);
    restartButton->setFixedWidth(buttonWidth);

    // Add components to the top layout
    topLayout->addWidget(hintButton);
    topLayout->addWidget(restartButton);
    topLayout->setAlignment(Qt::AlignRight);

    connect(this, &MainLayout::scoreUpdated, this, &MainLayout::updateScoreLabel);

    return topLayout;
}


QGridLayout* MainLayout::setupBottomLayout(QSize cellSize)
{
    gridLayout = new QGridLayout;

    gridLayout->setHorizontalSpacing(0);
    gridLayout->setVerticalSpacing(0);


    // Create and add buttons with cell images as icons
    for (int row = 0; row < numRows; ++row) {
        for (int col = 0; col < numCols; ++col) {
            CellButton *cellButton = new CellButton;
            QPixmap givenIcon = icons[CellType::EmptyCell];
            cellButton->setContentsMargins(0, 0, 0, 0);
            cellButton->setFixedHeight(cellSize.height() * 1.5);
            cellButton->setFixedWidth(cellSize.width());
            cellButton->setIcon(givenIcon);
            cellButton->setIconSize(givenIcon.size());
            gridLayout->addWidget(cellButton, row, col);


            // Connect the button's signals to slots in MainLayout
            connect(cellButton, &CellButton::leftClicked, this, [=]() {
                if (!isFlagged(row, col) && !isRevealed(row, col) && !isWaitUntilRestart()) {
                    if (isMineAtCell(row, col)) {
                        // Loose condition
                        // Cells are untouchable
                        setWaitUntilRestart(true);
                        // reveal all mines with signal
                        emit lost();
                        // pop up lose
                        showLostPopup();

                        qDebug() << "mine";
                    } else {
                        if (row == hintRow && col == hintCol){
                            hintPressedCount = 0;
                            hintRow = -1;
                            hintCol = -1;
                        }
                        // BFS
                        openNeighbors(grid, row, col);
                        // Check after bfs if hint is revealed
                        if (hintRow != -1 && hintCol != -1) {
                            if (isRevealed(hintRow, hintCol)) {
                                hintPressedCount = 0;
                                hintRow = -1;
                                hintCol = -1;
                            }
                        }
                    }
                }
            });

            // Signal slot connection to check if a cell should be revealed
            connect(this, &MainLayout::revealedCell, this, [=](int revealedRow, int revealedCol) {
                if (row == revealedRow && col == revealedCol) {
                    int neighbour = getCellNeighbour(row, col);
                    cellButton->setIcon(icons[neighbour]);
                    setRevealed(row, col, true);
                }
            });

            // Signal slot connection to check if a cell was right clicked
            connect(cellButton, &CellButton::rightClicked, this, [=]() {
                bool isHintCell = row == hintRow && col == hintCol;
                if (!isRevealed(row, col) && !isWaitUntilRestart() && !isHintCell) {
                    if (isFlagged(row, col)) {
                        cellButton->setIcon(icons[CellType::EmptyCell]);
                        setFlagged(row, col, false);
                    }
                    else {
                        cellButton->setIcon(icons[CellType::FlagCell]);
                        setFlagged(row, col, true);
                    }
                }
            });

            // Reveal all mines signal-slot for lose condition
            connect(this, &MainLayout::lost, cellButton, [=](){
                if (isMineAtCell(row, col))  cellButton->setIcon(icons[CellType::MineCell]);
            });

            // Reveal all mines signal-slot for win condition
            connect(this, &MainLayout::won, cellButton, [=](){
                if (isMineAtCell(row, col))  cellButton->setIcon(icons[CellType::MineCell]);
            });

            // Restart signal slot
            connect(this, &MainLayout::restart, cellButton, [=](){
                cellButton->setIcon(icons[CellType::EmptyCell]);
            });

            // Hint signal slot
            connect(this, &MainLayout::hint, cellButton, [=](int hintRow, int hintCol){
                if (row == hintRow && col == hintCol) {
                    cellButton->setIcon(icons[CellType::HintCell]);
                }
            });
        }
    }

    // Set the layout's size policy to Fixed
    setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    return gridLayout;
}

int MainLayout::getCols()
{
    return numCols;
}

int MainLayout::getRows()
{
    return numRows;
}

int MainLayout::getCellNeighbour(int row, int col)
{

    return (*grid)[row][col].getNeighborMineCount();
}

bool MainLayout::isMineAtCell(int row, int col)
{
    return (*grid)[row][col].getIsMine();
}

bool MainLayout::isRevealed(int row, int col)
{
    return (*grid)[row][col].getIsRevealed();
}

bool MainLayout::isFlagged(int row, int col)
{
    return (*grid)[row][col].getIsFlagged();
}

void MainLayout::setRevealed(int row, int col, bool reveal)
{
    (*grid)[row][col].setIsRevealed(reveal);
}

void MainLayout::setFlagged(int row, int col, bool flagged)
{
    (*grid)[row][col].setIsFlagged(flagged);
}

bool MainLayout::isWaitUntilRestart() {return waitUntilRestart;}

void MainLayout::setWaitUntilRestart(bool wait){
    waitUntilRestart = wait;
}

bool MainLayout::didWin(){
    bool won = true;
    for (int i = 0; i < getRows(); i++) {
        for (int j = 0; j < getCols(); j ++) {
            if (!isRevealed(i, j) && !isMineAtCell(i, j)) {
                won = false;
                break;
            }
        }
    }
    return won;
}

void MainLayout::showLostPopup()
{
    QMessageBox::information(this, "You lose!", "You lose!");
}

void MainLayout::showWonPopup()
{
    QMessageBox::information(this, "You win!", "You win!");
}

void MainLayout::openNeighbors( std::vector<std::vector<Cell>> *grid, int row, int col ){
    std::queue<Cell> myQueue;
    std::vector<Cell> visited;
    bfsHelper( grid, row, col, &myQueue, &visited );
    // calculate new score
    int newScore = calculateNewScore();
    emit scoreUpdated(newScore);
    // check win condition
    if (didWin()) {
        // Cells are untouchable
        setWaitUntilRestart(true);
        // reveal all mines
        emit won();
        // pop up win screen
        showWonPopup();
    }
}

void MainLayout::bfsHelper( std::vector<std::vector<Cell>> *grid, int row, int col, std::queue<Cell> *myQueue, std::vector<Cell> *visited ){
    // visit the current row and col
    (*grid)[row][col].setIsRevealed(true);
    emit revealedCell(row, col);
    (*visited).push_back((*grid)[row][col]);

    // if current cell's neinghbor mine count is > 0; dont add neighbors, pop from queue and run bfs again
    if((*grid)[row][col].getNeighborMineCount() > 0) {
        // pop the first element of the queue and run bfs for it
        if( myQueue->size()==0 )return;
        Cell first = (*myQueue).front();
        (*myQueue).pop();

        bfsHelper( grid, first.getRow(), first.getCol(), myQueue, visited );
        return;
    }

    // Add suitable cells to the queue
    int numRows = (*grid).size();
    int numCols = (*grid)[0].size();

    for(int rowAdd = -1; rowAdd < 2; rowAdd++){
        for(int colAdd = -1; colAdd < 2; colAdd++){
            if(colAdd == 0 && rowAdd == 0) continue;
            int neighborRow = row + rowAdd;
            int neighborCol = col + colAdd;
            if (neighborRow < 0 || neighborCol < 0 || neighborRow >= numRows || neighborCol >= numCols) continue;

            // not visited, add to the queue
            Cell currentCell = (*grid)[neighborRow][neighborCol];

            // check if the cell is visited
            bool isVisited = false;
            for(unsigned int i = 0; i < (*visited).size(); i++){
                if((*visited)[i].getRow() == neighborRow && (*visited)[i].getCol() == neighborCol){
                    isVisited = true;
                }
            }

            if( !isVisited ){
                // Add to the end of the queue
                (*myQueue).push( currentCell );
                (*visited).push_back( currentCell );
            }
        }
    }
    // pop the first element of the queue and run bfs for it
    if( myQueue->size()==0 )return;
    Cell first = (*myQueue).front();
    (*myQueue).pop();

    bfsHelper( grid, first.getRow(), first.getCol(), myQueue, visited );
}

int MainLayout::getScore() {
    return score;
}

void MainLayout::setScore(int newScore){
    score = newScore;
}

int MainLayout::calculateNewScore(){
    int score = 0;
    for (int i = 0; i < getRows(); i++) {
        for (int j = 0; j < getCols(); j++) {
            if (!isMineAtCell(i, j) && isRevealed(i, j)) score++;
        }
    }
    return score;
}

void MainLayout::updateScoreLabel(int newScore) {
    setScore(newScore);
    scoreLabel->setText("Score: " + QString::number(score));
}

void MainLayout::restartGame() {
    hintPressedCount = 0;
    hintRow = -1;
    hintCol = -1;
    *grid = createMap(getRows(), getCols(), numMines);
    for (int i = 0; i < getRows(); i++) {
        for (int j = 0; j < getCols(); j++){
            setRevealed(i, j, false);
            setFlagged(i, j, false);
        }
    }
    emit restart();
    emit scoreUpdated(0);
    setWaitUntilRestart(false);
}

std::vector<std::vector<Cell>> MainLayout::createMap( int numRows, int numCols, int numOfMines){
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

QIcon MainLayout::getMineIcon(){
    return icons[CellType::MineCell];
}

int* MainLayout::giveHint(std::vector<std::vector<Cell>> *grid){
    int numRows = (*grid).size();
    int numCols = (*grid)[0].size();

    // Create a 2d array to store temporary states of the cells

    /*
    0 --> not determined
    -1 --> mine guarenteed
    1 --> empty guaranteed
    */

    int hintState[numRows][numCols];
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            Cell currentCell = (*grid)[i][j];
            // if isRevealed, empty guaranteed
            if(currentCell.getIsRevealed()) hintState[i][j] = 1;
            //else, not deteremined
            else hintState[i][j] = 0;
        }
    }

    bool inferredInfo = true;

    while( inferredInfo ){
        inferredInfo = false;

        // Traverse all cells
        for (int i = 0; i < numRows; ++i) {
            for (int j = 0; j < numCols; ++j) {
                Cell currentCell = (*grid)[i][j];

                // if the cell has neihgboring mines
                if(currentCell.getIsRevealed() && currentCell.getNeighborMineCount() > 0){

                    int mineNumber = currentCell.getNeighborMineCount();

                    // Count the number of guaranteed mine, empty and not determined neighbors
                    int numGuaranteedMineNeighs = 0;
                    int numGuaranteedEmptyNeighs = 0;
                    int numNotDeterminedNeighs = 0;

                    // Traverse all neighbors and check their states
                    for(int rowAdd = -1; rowAdd < 2; rowAdd++){
                        for(int colAdd = -1; colAdd < 2; colAdd++){
                            if(colAdd == 0 && rowAdd == 0) continue;
                            int neighborRow = i + rowAdd;
                            int neighborCol = j + colAdd;
                            if (neighborRow < 0 || neighborCol < 0 || neighborRow >= numRows || neighborCol >= numCols) continue;

                            if(hintState[neighborRow][neighborCol] == 0) numNotDeterminedNeighs++;
                            else if(hintState[neighborRow][neighborCol] == 1) numGuaranteedEmptyNeighs++;
                            else if(hintState[neighborRow][neighborCol] == -1) numGuaranteedMineNeighs++;
                        }
                    }

                    if( (mineNumber == numGuaranteedMineNeighs + numNotDeterminedNeighs) && numNotDeterminedNeighs > 0){
                        // All not determined neighbors are guaranteedMine
                        for(int rowAdd = -1; rowAdd < 2; rowAdd++){
                            for(int colAdd = -1; colAdd < 2; colAdd++){
                                if(colAdd == 0 && rowAdd == 0) continue;
                                int neighborRow = i + rowAdd;
                                int neighborCol = j + colAdd;
                                if (neighborRow < 0 || neighborCol < 0 || neighborRow >= numRows || neighborCol >= numCols) continue;

                                if(hintState[neighborRow][neighborCol] == 0) {
                                    hintState[neighborRow][neighborCol] = -1;
                                    inferredInfo = true;
                                }
                            }
                        }
                    }

                    else if( (mineNumber == numGuaranteedMineNeighs) && numNotDeterminedNeighs >0){
                        // All not determined mines are guaranteedEmpty
                        for(int rowAdd = -1; rowAdd < 2; rowAdd++){
                            for(int colAdd = -1; colAdd < 2; colAdd++){
                                if(colAdd == 0 && rowAdd == 0) continue;
                                int neighborRow = i + rowAdd;
                                int neighborCol = j + colAdd;
                                if (neighborRow < 0 || neighborCol < 0 || neighborRow >= numRows || neighborCol >= numCols) continue;

                                if(hintState[neighborRow][neighborCol] == 0) {
                                    hintState[neighborRow][neighborCol] = 1;
                                    inferredInfo = true;
                                }
                            }
                        }
                    }

                    else{
                        // no info can be inferred
                    }


                } else {
                    // no information can be inferred
                }

            }
        }
    }

    // Choose a guaranteedEmpty from the hintState array
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            if(hintState[i][j] == 1 && (*grid)[i][j].getIsRevealed() == false){
                int *returnCoordinates = new int[2];
                returnCoordinates[0] = i;
                returnCoordinates[1] = j;
                return returnCoordinates;
            }
        }
    }

    // if not found, return NULL
    return NULL;
}



