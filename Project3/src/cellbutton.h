#ifndef CELLBUTTON_H
#define CELLBUTTON_H

#include <QPushButton>

class CellButton : public QPushButton {
    Q_OBJECT

public:
    explicit CellButton(QWidget *parent = nullptr);

signals:
    void leftClicked();
    void rightClicked();

protected:
    void mousePressEvent(QMouseEvent *event) override;
};

#endif // CELLBUTTON_H
