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

#include "appprofiles.h"
#include <KConfig>
#include <KConfigGroup>
#include <QDir>

namespace UFW
{

namespace AppProfiles
{

Entry::Entry(const QString &n, const QString &p)
     : name(n), ports(p)
{
    ports.replace('|', ' ');
}

/* TODO: Find a way to fix this.
 this feels really wrong. a Function that returns a reference
for a static variable created inside of it.
*/
const QList<Entry> & get()
{
    static QList<Entry> profiles;
    static bool         init=false;

    if(!init)
    {
        static const char * constProfileDir="/etc/ufw/applications.d/";

        QStringList                files(QDir(constProfileDir).entryList());
        QStringList::ConstIterator it(files.constBegin()),
                                   end(files.constEnd());

        for(; it!=end; ++it)
            if((*it)!="." && (*it)!="..")
            {
                KConfig                    cfg(constProfileDir+(*it), KConfig::SimpleConfig);
                QStringList                groups(cfg.groupList());
                QStringList::ConstIterator gIt(groups.constBegin()),
                                           gEnd(groups.constEnd());

                for(; gIt!=gEnd; ++gIt)
                {
                    QString ports(cfg.group(*gIt).readEntry("ports", QString()));

                    if(!ports.isEmpty() && !profiles.contains(*gIt))
                        profiles.append(Entry(*gIt, ports));
                }
            }
        qSort(profiles);
    }

    return profiles;
}

Entry get(const QString &name)
{
    // This feels *so* wrong.
    for(const auto entry : qAsConst(get())) {
        if (entry.name == name) {
            return entry;
        }
    }
    return Entry({});
}

}

}
