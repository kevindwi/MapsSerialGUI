#include <QApplication>
#include <QQmlApplicationEngine>

#include "mapserial.h"
#include "markermodel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<MapSerial>("com.mapview.MapSerial", 1, 0, "MapSerial");

    qmlRegisterType<MarkerModel>("com.mapview.MarkerModel", 1, 0, "MarkerModel");

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
