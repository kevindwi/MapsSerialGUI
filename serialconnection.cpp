#include "serialconnection.h"

SerialConnection::SerialConnection(QObject *parent)
    : QObject{parent}
    , m_serial(new QSerialPort(this))
{
    connect(m_serial, &QSerialPort::readyRead, this, &SerialConnection::dataReady);
}

QList<QString> SerialConnection::getPortInfo()
{
    QList<QString> ports;

    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos)
        // if(info.portName() )
        ports.append(info.portName());

    return ports;
}

bool SerialConnection::openSerialPort(QString portName, qint32 baudRate)
{
    // if (m_serial != nullptr) {
    //     m_serial->close();
    //     delete m_serial;
    // }

    m_serial->setPortName(portName);
    m_serial->setBaudRate(baudRate);
    if (m_serial->open(QIODevice::ReadWrite)) {
        connect(m_serial, &QSerialPort::readyRead, this, &SerialConnection::dataReady);
    } else {
        qDebug() << tr("Open error");
        qDebug() << m_serial->errorString();
    }

    return m_serial->isOpen();
}

void SerialConnection::closeSerialPort()
{
    if (m_serial->isOpen())
        m_serial->close();

    qDebug() << "Disconnected";
}

qint64 SerialConnection::writeData(const QByteArray &data)
{
    if (m_serial == nullptr || !m_serial->isOpen()) {
        return -1;
    }
    return m_serial->write(data);
}

SerialConnection::~SerialConnection()
{
    closeSerialPort();
}

void SerialConnection::dataReady()
{
    if(m_serial->isOpen()) {
        // qDebug() << m_serial->readAll();
        emit dataReceived(m_serial->readAll());
    }
}
