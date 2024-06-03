#include "window.h"
#include "CellButton.h" // Include the CellButton header file

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

Window::Window(QWidget* parent) :
    QWidget(parent)
{
    gridLayout = new QGridLayout(this);
    gridLayout->setSpacing(0); // Set spacing between cells to 0
    setFixedSize(400, 400);    // Set fixed window size

    createGrid(10, 10);
}

void Window::createGrid(int n, int m)
{
    // Images vector
    std::vector<QString> imagePaths;
    for (int i = 0; i <= 12; ++i) {
        imagePaths.push_back("/Users/hikmetcankoseoglu/Qt/Projects/mine_sweeper/assets/" + QString::number(i) + ".png");
    }

    int cellWidth = (width() / m);
    int cellHeight = (height() / n);

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            CellButton* button = new CellButton(imagePaths[CellType::EmptyCell], this);
            QSize scaledIconSize = button->icon().actualSize(QSize(cellWidth * 10, cellHeight * 10));
            button->setIconSize(scaledIconSize);
            button->setFixedSize(cellWidth, cellHeight); // Set fixed size for each cell
            button->setStyleSheet("margin: 0; padding: 0;"); // Remove margins and borders
            gridLayout->addWidget(button, i, j);
        }
    }
}
