#ifndef MAPCOORDINATE_H
#define MAPCOORDINATE_H

#include <QObject>
#include <QDebug>

class MapCoordinate : public QObject
{
    Q_OBJECT
public:
    explicit MapCoordinate(QObject *parent = nullptr);

    void getCoordinates(double latitude, double longitude);

private:
    float m_endpoint;

signals:
};

#endif // MAPCOORDINATE_H
