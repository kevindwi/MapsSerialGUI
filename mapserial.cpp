#include "mapserial.h"

MapSerial::MapSerial(QObject *parent)
    : QObject{parent}
{
    connect(&serial, &SerialConnection::dataReceived, this, &MapSerial::readData);
}

bool MapSerial::startConnection(QString portName, qint32 baudRate)
{
    if(serial.openSerialPort(portName, baudRate)) {
        qDebug() << "Port Connected";
        return true;
    } else {
        messageBox.setText("Error connecting to port.");
        messageBox.exec();
        return false;
    }
}

void MapSerial::closeConnection()
{
    serial.closeSerialPort();
}

void MapSerial::readData(QByteArray data)
{
    QByteArray ba;
    bool finished(false);
    ba = data;
    for(int i(0); i < ba.size(); i++){
        if(ba[i] != 0x0D)
            message.append(ba[i]);
        else finished = true;
    }

    if(finished){
        qDebug() << message.replace("\n", "").split(",");
        message.clear();
    }
}

QList<QString> MapSerial::getPortList()
{
    return serial.getPortInfo();
}

void MapSerial::getMarkerCoordinates(double latitude, double longitude)
{
    qDebug() << qSetRealNumberPrecision(10) << latitude << longitude;
}
