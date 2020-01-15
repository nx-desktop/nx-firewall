/*
 * Copyright 2018 Alexis Lopes Zubeta <contact@azubieta.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "ufwplugin.h"
#include "ufwclient.h"
#include "rulelistmodel.h"
#include "rulewrapper.h"
#include "loglistmodel.h"

#include <QtQml>

void UfwPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.nomad.ufw"));

    qmlRegisterType<UfwClient>(uri, 1, 0, "UfwClient");
    qmlRegisterType<RuleListModel>(uri, 1, 0, "RuleListModel");
    qmlRegisterType<RuleWrapper>(uri, 1, 0, "Rule");
    qmlRegisterUncreatableType<LogListModel>(uri, 1, 0, "LogListModel", "Only created from the UfwClient.");
}
