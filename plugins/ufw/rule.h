#ifndef UFW_RULE_H
#define UFW_RULE_H

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

#include "types.h"
#include <QString>
#include <QObject>

class QDomElement;

namespace UFW
{

class Rule
{
    public:

    static int     getServicePort(const QString &name);
    static QString protocolSuffix(Types::Protocol prot, const QString &sep=QString("/"));
    static QString modify(const QString &address, const QString &port, const QString &application,
                          const QString iface, const Types::Protocol &protocol, bool matchPortNoProto=false);

    Rule();
    Rule(QDomElement &elem);
    Rule(Types::Policy pol, bool in, Types::Logging log, Types::Protocol prot,
//          const QString &descr=QString(), const QString &hsh=QString(),
         const QString &srcHost=QString(), const QString &srcPort=QString(),
         const QString &destHost=QString(), const QString &destPort=QString(),
         const QString &ifaceIn=QString(), const QString &ifaceOut=QString(),
         const QString &srcApp=QString(), const QString &destApp=QString(),
         unsigned int i=0)
        : position(i), action(pol), incoming(in), v6(false), protocol(prot), logtype(log),
          destApplication(destApp), sourceApplication(srcApp),
          destAddress(destHost), sourceAddress(srcHost), destPort(destPort), sourcePort(srcPort),
          interfaceIn(ifaceIn), interfaceOut(ifaceOut) // , description(descr), hash(hsh)
          { }


    QString       toStr() const;
    QString       fromStr() const;
    QString       actionStr() const;
    QString       protocolStr() const;
    QString       ipV6Str() const;
    QString       loggingStr() const;
    QString       toXml() const;

    int             getPosition() const          { return position; }
    Types::Policy   getAction() const            { return action; }
    bool            getIncoming() const          { return incoming; }
    bool            getV6() const                { return v6; }
    const QString & getDestApplication() const   { return destApplication; }
    const QString & getSourceApplication() const { return sourceApplication; }
    const QString & getDestAddress() const       { return destAddress; }
    const QString & getSourceAddress() const     { return sourceAddress; }
    const QString & getDestPort() const          { return destPort; }
    const QString & getSourcePort() const        { return sourcePort; }
    const QString & getInterfaceIn() const       { return interfaceIn; }
    const QString & getInterfaceOut() const      { return interfaceOut; }
    Types::Protocol getProtocol() const          { return protocol; }
    Types::Logging  getLogging() const           { return logtype; }
//     const QString & getDescription() const       { return description; }
//     const QString & getHash() const              { return hash; }

    void setPosition(unsigned int v)            { position=v; }
    void setAction(Types::Policy v)             { action=v; }
    void setIncoming(bool v)                    { incoming=v; }
    void setV6(bool v)                          { v6=v; }
    void setDestApplication(const QString &v)   { destApplication=v; }
    void setSourceApplication(const QString &v) { sourceApplication=v; }
    void setDestAddress(const QString &v)       { destAddress=v; }
    void setSourceAddress(const QString &v)     { sourceAddress=v; }
    void setDestPort(const QString &v)          { destPort=v; }
    void setSourcePort(const QString &v)        { sourcePort=v; }
    void setInterfaceIn(const QString &v)       { interfaceIn=v; }
    void setInterfaceOut(const QString &v)      { interfaceOut=v; }
    void setProtocol(Types::Protocol v)         { protocol=v; }
    void setLogging(Types::Logging v)           { logtype=v; }
//     void setDescription(const QString &v)       { description=v; }
//     void setHash(const QString &v)              { hash=v; }

    // 'different' is used in the EditRule dialog to know whether the rule has actually changed...
    bool different(const Rule &o) const
    {
        return logtype!=o.logtype /*|| description!=o.description*/ || !(*this==o);
    }

//     bool onlyDescrChanged(const Rule &o) const
//     {
//         return (*this==o) && logtype==o.logtype && description!=o.description;
//     }

    bool operator==(const Rule &o) const
    {
        return action==o.action &&
               incoming==o.incoming &&
               v6==o.v6 &&
               protocol==o.protocol &&
               //logtype==o.logtype &&
               destApplication==o.destApplication &&
               sourceApplication==o.sourceApplication &&
               destAddress==o.destAddress &&
               sourceAddress==o.sourceAddress &&
               (destApplication.isEmpty() && o.destApplication.isEmpty() ? destPort==o.destPort : true) &&
               (sourceApplication.isEmpty() && o.sourceApplication.isEmpty() ? sourcePort==o.sourcePort : true) &&
               interfaceIn==o.interfaceIn &&
               interfaceOut==o.interfaceOut;
    }

    private:

    int             position;
    Types::Policy   action;
    bool            incoming,
                    v6;
    Types::Protocol protocol;
    Types::Logging  logtype;
    QString         destApplication,
                    sourceApplication,
                    destAddress,
                    sourceAddress,
                    destPort,
                    sourcePort,
                    interfaceIn,
                    interfaceOut;
//                     description,
//                     hash;
};

}

#endif
