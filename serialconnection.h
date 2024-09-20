#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>

class SerialConnection : public QObject
{
    Q_OBJECT
public:
    explicit SerialConnection(QObject *parent = nullptr);
    ~SerialConnection();

    Q_INVOKABLE QList<QString> getPortInfo();
    bool openSerialPort(QString portName, qint32 baudRate);
    void closeSerialPort();
    qint64 writeData(const QByteArray &data);

private slots:
    void dataReady();

private:
    QSerialPort *m_serial = nullptr;

signals:
    void dataReceived(QByteArray b);

};

#endif // SERIALCONNECTION_H
