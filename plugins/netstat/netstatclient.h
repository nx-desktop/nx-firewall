#ifndef NETSTATCLIENT_H
#define NETSTATCLIENT_H

#include <QObject>

class NetstatClient : public QObject
{
    Q_OBJECT
public:
    explicit NetstatClient(QObject *parent = nullptr);

signals:

public slots:
};

#endif // NETSTATCLIENT_H