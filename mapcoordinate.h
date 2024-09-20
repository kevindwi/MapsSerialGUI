#ifndef MAPCOORDINATE_H
#define MAPCOORDINATE_H

#include <QObject>
#include <QDebug>

class MapCoordinate : public QObject
{
    Q_OBJECT
public:
    explicit MapCoordinate(QObject *parent = nullptr);

    Q_INVOKABLE void getCoordinates(float latitude, float longitude);

private:
    float m_endpoint;

signals:
};

#endif // MAPCOORDINATE_H
