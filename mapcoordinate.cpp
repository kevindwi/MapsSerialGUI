#include "mapcoordinate.h"

MapCoordinate::MapCoordinate(QObject *parent)
    : QObject{parent}
{}

void MapCoordinate::getCoordinates(float latitude, float longitude)
{
    // m_endpoint = point;

    // QGeoCoordinate segment = m_endpoint;
    qDebug() << qSetRealNumberPrecision(10) << latitude << longitude;
}
