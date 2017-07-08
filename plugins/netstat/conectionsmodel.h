#ifndef CONECTIONSMODEL_H
#define CONECTIONSMODEL_H

#include <QAbstractListModel>

class ConectionsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ConectionsModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

private:
};

#endif // CONECTIONSMODEL_H