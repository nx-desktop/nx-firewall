#ifndef UFWCLIENT_H
#define UFWCLIENT_H

#include <QObject>

class UfwClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isActive READ isActive);
public:
    explicit UfwClient(QObject *parent = nullptr);

    bool isActive();
signals:

public slots:
};

#endif // UFWCLIENT_H
