#ifndef UFW_HELPER_H
#define UFW_HELPER_H

/*
 * UFW KControl Module
 *
 * Copyright 2011 Craig Drummond <craig.p.drummond@gmail.com>
 *
 * ----
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include <QtCore/QObject>
#include <QtCore/QVariantMap>
#include <kauth.h>

class QStringList;
class QByteArray;

using namespace KAuth;

namespace UFW
{

class LogLister;

class Helper : public QObject
{
    Q_OBJECT

    public:

    enum Status
    {
        STATUS_OK,
        STATUS_INVALID_CMD       = -100,
        STATUS_INVALID_ARGUMENTS = -101,
        STATUS_OPERATION_FAILED  = -102,
    };

    public Q_SLOTS:

    ActionReply query(const QVariantMap &args);
    ActionReply viewlog(const QVariantMap &args);
    ActionReply modify(const QVariantMap &args);

    private:

    ActionReply setStatus(const QVariantMap &args, const QString &cmd);
    ActionReply setDefaults(const QVariantMap &args, const QString &cmd);
    ActionReply setModules(const QVariantMap &args, const QString &cmd);
    ActionReply setProfile(const QVariantMap &args, const QString &cmd);
    ActionReply saveProfile(const QVariantMap &args, const QString &cmd);
    ActionReply deleteProfile(const QVariantMap &args, const QString &cmd);
    ActionReply addRules(const QVariantMap &args, const QString &cmd);
    ActionReply removeRule(const QVariantMap &args, const QString &cmd);
    ActionReply moveRule(const QVariantMap &args, const QString &cmd);
    ActionReply editRule(const QVariantMap &args, const QString &cmd);
//     ActionReply editRuleDescr(const QVariantMap &args, const QString &cmd);
    ActionReply reset(const QString &cmd);
    ActionReply run(const QStringList &args, const QString &cmd);
    ActionReply run(const QStringList &args, const QStringList &second, const QString &cmd);

    private:

    LogLister *lister;
};

}

#endif
