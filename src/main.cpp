#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQuick>
#include <QDebug>
#include "filghtdatagenerator.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    using namespace FlightData::Generator;

    QQmlApplicationEngine engine;


    FlightDataGenerator generator;

    engine.rootContext()->setContextProperty("generate",&generator);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;



    return app.exec();

}
