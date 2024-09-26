#ifndef MAPSERIAL_H
#define MAPSERIAL_H

#include <QObject>
#include <QMessageBox>
#include <QGeoCoordinate>
#include <QAbstractListModel>
#include <QVariant>

#include "serialconnection.h"

class MapSerial : public QObject
{
    Q_OBJECT
public:

    explicit MapSerial(QObject *parent = nullptr);
    Q_INVOKABLE QList<QString> getPortList();
    Q_INVOKABLE bool startConnection(QString portName, qint32 baudRate);
    Q_INVOKABLE void closeConnection();

    Q_INVOKABLE void getMarkerCoordinates(double latitude, double longitude);

    QMessageBox messageBox;

private slots:
    void readData(QByteArray data);

private:
    SerialConnection serial;
    QString message;
    QList<QGeoCoordinate> m_coordinates;

signals:
};

#endif // MAPSERIAL_H
