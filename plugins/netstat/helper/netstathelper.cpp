#include "netstathelper.h"

#include <QDebug>
#include <QProcess>
#include <QStringList>

#include "netstat_helper_config.h"

NetstatHelper::NetstatHelper()
{

}

KAuth::ActionReply NetstatHelper::query(const QVariantMap &args)
{
    KAuth::ActionReply reply;

    QProcess    netstat;
    QStringList netstatArgs("-ntuap");
    qDebug() << "run" << NETSTAT_BINARY_PATH << netstatArgs;

    netstat.start(NETSTAT_BINARY_PATH, netstatArgs, QIODevice::ReadOnly);
    if (netstat.waitForStarted())
        netstat.waitForFinished();

    int exitCode(netstat.exitCode());

    if(0 != exitCode)
    {
        qWarning() << "netstat command exit with code: " << exitCode;

        reply=KAuth::ActionReply::HelperErrorReply(exitCode);
        reply.addData("response", netstat.readAllStandardError());
    } else {
        QVariantList connections = parseOutput(netstat.readAllStandardOutput());
//        qDebug() << connections;
        reply.addData("connections", connections);
    }

    return reply;
}

QVariantList NetstatHelper::parseOutput(const QByteArray &netstatOutput)
{
    QString rawOutput = netstatOutput;
    QStringList outputLines = rawOutput.split("\n");

    QVariantList connections;

    int lineIdx = 0;
    int protIndex = 0, protSize = 0,
            localAddressIndex, localAddressSize,
            foreingAddressIndex, foreingAddressSize,
            stateIndex, stateSize, processIndex, processSize;

    for (auto line : outputLines)
    {
//        qDebug() << line;

        lineIdx ++;
        if (line.isEmpty())
            continue;

        if (lineIdx == 1)
            continue;

        if (lineIdx == 2) {
            protIndex = 0;
            protSize = line.indexOf("Recv-Q");

            localAddressIndex = line.indexOf("Local Address");
            localAddressSize = line.indexOf("Foreign Address") - localAddressIndex;

            foreingAddressIndex = line.indexOf("Foreign Address");
            foreingAddressSize = line.indexOf("State") - foreingAddressIndex;

            stateIndex = line.indexOf("State");
            stateSize = line.indexOf("PID/Program name") - stateIndex;

            processIndex = line.indexOf("PID/Program name");
            processSize = line.size() - processSize;

            continue;
        }

        QVariantList connection;

        connection << extractAndStrip(line, protIndex, protSize);
        connection << extractAndStrip(line, localAddressIndex, localAddressSize);
        connection << extractAndStrip(line, foreingAddressIndex, foreingAddressSize);
        connection << extractAndStrip(line, stateIndex, stateSize);
        QString pidAndProcess = extractAndStrip(line, processIndex, processSize);

        int slashIndex = pidAndProcess.indexOf("/");
        if (slashIndex != -1) {
            QString pidStr = pidAndProcess.left(slashIndex);
            QString program = pidAndProcess.right(pidAndProcess.size() - slashIndex - 1);
            program = program.section(":",0,0);

            connection << pidStr.toInt();
            connection << program;
        }


        connections.append(connection);
    }

    return connections;
}

QString NetstatHelper::extractAndStrip(const QString &src, const int &index, const int &size) {
    QString str = src.mid(index, size);
    str.replace(" ", "");
    return str;
}

KAUTH_HELPER_MAIN("org.nxos.netstat", NetstatHelper)
