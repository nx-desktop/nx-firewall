#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QDebug>
#include <QIcon>
#include <QtQml>
#include <QQmlEngine>


int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);
    QCoreApplication::addLibraryPath("./");

    app.setWindowIcon(QIcon::fromTheme("security-high"));
    QQmlApplicationEngine engine;

    const char * uri = "org.nomad.firewall";

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}


