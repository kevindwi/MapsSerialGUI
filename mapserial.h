#ifndef MAPSERIAL_H
#define MAPSERIAL_H

#include <QObject>

class MapSerial : public QObject
{
    Q_OBJECT
public:
    explicit MapSerial(QObject *parent = nullptr);

signals:
};

#endif // MAPSERIAL_H
