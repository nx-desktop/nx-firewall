#ifndef LOGLISTMODEL_H
#define LOGLISTMODEL_H

#include <QAbstractListModel>
#include <QVariantList>

class LogListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit LogListModel(QObject *parent = nullptr);

    enum LogItemModelRoles
    {
        SourceAddressRole = Qt::UserRole + 1,
        SourcePortRole,
        DestinationAddressRole,
        DestinationPortRole,
        ProtocolRole,
        InterfaceRole,
        ActionRole,
        TimeRole,
        DateRole,
    };


    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    void addRawLogs(QStringList rawLogsList);
protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QVariantList m_logsData;
};

#endif // LOGLISTMODEL_H
