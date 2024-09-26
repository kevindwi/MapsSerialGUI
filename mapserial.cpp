#include "mapserial.h"

MapSerial::MapSerial(QObject *parent)
    : QObject{parent}
{
    connect(&serial, &SerialConnection::dataReceived, this, &MapSerial::readData);
    // connect(&serial, &SerialConnection::dataReceived, qmlObject, SLOT(setCurrentCoordinate));
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
        // qDebug() << message.replace("\n", "").split(",");
        QStringList msgList = message.replace("\n", "").split(",");

        if(msgList.length() == 4)
        {
            m_coordinates.setLatitude(msgList[0].toDouble());
            m_coordinates.setLongitude(msgList[1].toDouble());
            // qDebug() << m_coordinates;
        }

        emit dataReceived(message, m_coordinates);
        message.clear();
    }
}

void MapSerial::sendData(QString data)
{
    QByteArray buffer = data.toUtf8() + "\n";
    serial.writeData(buffer);
}

QList<QString> MapSerial::getPortList()
{
    return serial.getPortInfo();
}

void MapSerial::getMarkerCoordinates(double latitude, double longitude)
{
    qDebug() << qSetRealNumberPrecision(10) << latitude << longitude;
}


QGeoCoordinate MapSerial::getCurrentPosition()
{
    return m_coordinates;
}
