#ifndef WINDOW_H
#define WINDOW_H

#include <QWidget>
#include <QGridLayout>
#include <QLabel>
#include <QPixMap>

class Window : public QWidget
{
    Q_OBJECT
public:
    explicit Window(QWidget *parent = 0);
signals:
private slots:
private:
    void createGrid(int n, int m);
    QGridLayout *gridLayout;
};

#endif // WINDOW_H
