#include <QApplication>
#include <QQmlApplicationEngine>
#include <QObject>

#include "mapserial.h"
#include "markermodel.h"
#include "serialconnection.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<MapSerial>("com.mapview.MapSerial", 1, 0, "MapSerial");

    qmlRegisterType<MarkerModel>("com.mapview.MarkerModel", 1, 0, "MarkerModel");

    MapSerial m;

    // connect(&m.serial, &SerialConnection::dataReceived, engine.rootObjects().at(0)->findChild<QObject*>("map"), SLOT(setCurrentCoordinate()));

    // engine.rootContext()->setContextProperty("myobj",myobj);

    const QUrl url(QStringLiteral("qrc:main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);


    engine.load(url);

    return app.exec();
}
