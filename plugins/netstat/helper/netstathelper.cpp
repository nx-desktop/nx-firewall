#include "netstathelper.h"

#include <QDebug>
#include <QProcess>
#include <QStringList>

NetstatHelper::NetstatHelper()
{
    int exitCode = QProcess::execute("netstat", {"--version"});
    if (exitCode == -2) { // could not execute file
        qWarning() << "netstat is not installed or not in the PATH, please configure system.";
        mHasNetstat = false;
    } else {
        mHasNetstat = true;
    }

    exitCode = QProcess::execute("ss", {"--version"});
    if (exitCode == -2) { // could not execute file
        qWarning() << "ss is not installed or not in the PATH, install iptroute-2.";
        mHasSS = false;
    } else {
        mHasSS = true;
    }
}

KAuth::ActionReply NetstatHelper::query(const QVariantMap)
{
    KAuth::ActionReply reply;

    QProcess    netstat;
    QStringList netstatArgs("-ntuap");
    QString executable = mHasSS ? QStringLiteral("ss")
                      : mHasNetstat ? QStringLiteral("netstat")
                      : QString();

    if (executable.isEmpty()) {
        qWarning() << "No iproute or net-tools installed, can't run.";
        KAuth::ActionReply::HelperErrorReply(-2);
        return {};
    }

    qDebug() << "run" << executable << netstatArgs;

    netstat.start(executable, netstatArgs, QIODevice::ReadOnly);
    if (netstat.waitForStarted())
        netstat.waitForFinished();

    int exitCode(netstat.exitCode());

    if(0 != exitCode)
    {
        reply=KAuth::ActionReply::HelperErrorReply(exitCode);
        reply.addData("response", netstat.readAllStandardError());
    } else {
        QVariantList connections = parseOutput(netstat.readAllStandardOutput());
        reply.addData("connections", connections);
    }

    return reply;
}

QVariantList NetstatHelper::parseOutput(const QByteArray &netstatOutput)
{
    if (mHasSS) {
        return parseSSOutput(netstatOutput);
    } else if (mHasNetstat) {
        return parseNetstatOutput(netstatOutput);
    }
    return {};
}

QVariantList NetstatHelper::parseSSOutput(const QByteArray &netstatOutput)
{
   QString rawOutput = netstatOutput;
    QStringList outputLines = rawOutput.split("\n");

    QVariantList connections;

    // discard lines.
    while (outputLines.size()) {
        if (outputLines.first().indexOf("Recv-Q")) {
            outputLines.removeFirst();
            break;
        }
        outputLines.removeFirst();
    }

    // can't easily parse because of the spaces in Local and Peer AddressPort.
    QStringList headerLines = {
        i18n("Netid"),
        i18n("State"),
        i18n("Recv-Q"),
        i18n("Send-Q"),
        i18n("Local Address:Port"),
        i18n("Peer Address:Port"),
        i18n("Process"),
    };

    /* Insertion order:
        ProtocolRole = Qt::UserRole + 1,
        LocalAddressRole,
        ForeignAddressRole,
        StatusRole,
        PidRole,
        ProgramRole
    */
    // Extract Information
    for (auto line : outputLines)
    {
        QStringList values = line.split(" ", Qt::SkipEmptyParts);

        // Some lines lack one or two values.
        while (values.size() < headerLines.size()) {
            values.append(QString());
        }

        QString appName;
        QString pid;

        // TODO: Extract Pid and Program correctly.
        if (values[6].size()) {
            values[6].remove(0, QStringLiteral("users:((").size());
            values[6].chop(QStringLiteral("))").size());

            QStringList substrings = values[6].split(',');
            appName = substrings[0].remove("\"");
            pid = substrings[1].split('=')[1];
        }

        QVariantList connection {
            values[0], // NetId
            values[4], // Local Address
            values[5], // Peer Address,
            values[1], // State
            pid, // Pid + Program. //TODO: Extract program name.
            appName,
        };

        connections.append((QVariant) connection);
    }

    return connections;
}

QVariantList NetstatHelper::parseNetstatOutput(const QByteArray &netstatOutput)
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


        connections.append((QVariant) connection);
    }

    return connections;
}

QString NetstatHelper::extractAndStrip(const QString &src, const int &index, const int &size) {
    QString str = src.mid(index, size);
    str.replace(" ", "");
    return str;
}

KAUTH_HELPER_MAIN("org.nxos.netstat", NetstatHelper)
