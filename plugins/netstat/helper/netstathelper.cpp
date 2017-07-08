#include "netstathelper.h"

#include <QDebug>
#include <QProcess>
#include <QStringList>

#include "netstat_helper_config.h"

NetstatHelper::NetstatHelper()
{

}

KAuth::ActionReply NetstatHelper::queryActiveConnections(const QVariantMap &args)
{
    KAuth::ActionReply reply;

    QProcess    netstat;
    QStringList netstatArgs;
    qDebug() << __FUNCTION__ ;

    netstat.start(NETSTAT_BINARY_PATH, netstatArgs, QIODevice::ReadOnly);
    if (netstat.waitForStarted())
        netstat.waitForFinished();

    int exitCode(netstat.exitCode());

    qDebug() << exitCode;
    qDebug() << netstat.readAllStandardOutput();

    if(0!=exitCode)
    {
        reply=KAuth::ActionReply::HelperErrorReply(exitCode);
        reply.addData("response", netstat.readAllStandardError());
    }
    else
        reply.addData("response", netstat.readAllStandardOutput());
//    reply.addData("cmd", cmd);
    return reply;

}

KAUTH_HELPER_MAIN("org.nomad.netstat", NetstatHelper)
