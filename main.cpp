#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "mapcoordinate.h"
#include <serialconnection.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<MapCoordinate>("com.mapview.MapCoordinate", 1, 0, "MapCoordinate");
    qmlRegisterType<SerialConnection>("com.mapview.SerialConnection", 1, 0, "SerialConnection");

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
