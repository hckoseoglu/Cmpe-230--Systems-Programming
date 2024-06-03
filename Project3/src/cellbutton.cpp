#include "cellbutton.h"
#include <QMouseEvent>

CellButton::CellButton(QWidget *parent) : QPushButton(parent) {}

// Function for handling mouse events
void CellButton::mousePressEvent(QMouseEvent *event) {
    if (event->button() == Qt::LeftButton) {
        emit leftClicked();
    } else if (event->button() == Qt::RightButton) {
        emit rightClicked();
    }
    QPushButton::mousePressEvent(event);
}
