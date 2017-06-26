#include "rulewrapper.h"

#include "types.h"
#include <QDebug>

RuleWrapper::RuleWrapper(QObject *parent) : QObject(parent)
{

}

RuleWrapper::RuleWrapper(UFW::Rule rule, QObject *parent) : QObject(parent), m_rule(rule)
{

}

QString RuleWrapper::policy() const
{
    auto policy = m_rule.getAction();
    return UFW::Types::toString(policy);
}

bool RuleWrapper::incoming() const
{
    return m_rule.getIncoming();
}

QString RuleWrapper::sourceAddress() const
{
    return m_rule.getSourceAddress();
}

QString RuleWrapper::sourcePort() const
{
    return m_rule.getSourcePort();
}

QString RuleWrapper::destinationAddress() const
{
    return m_rule.getDestAddress();
}

QString RuleWrapper::destinationPort() const
{
    return m_rule.getDestPort();
}

int RuleWrapper::protocol() const
{
    auto protocol = m_rule.getProtocol();
    return protocol;
}

QString RuleWrapper::interface() const
{
    return m_rule.getInterfaceIn();
}

QString RuleWrapper::logging() const
{
    auto logging = m_rule.getLogging();
    return UFW::Types::toString(logging);
}

UFW::Rule RuleWrapper::getRule()
{
    return m_rule;
}

int RuleWrapper::position() const
{
    return m_rule.getPosition();
}

void RuleWrapper::setPolicy(QString policy)
{
    auto policy_t = UFW::Types::toPolicy(policy);

    if (policy_t == m_rule.getAction())
        return;

    m_rule.setAction(policy_t);
    emit policyChanged(policy);
}

void RuleWrapper::setIncoming(bool incoming)
{
    if (m_rule.getIncoming() == incoming)
        return;

    m_rule.setIncoming(incoming);
    emit incomingChanged(incoming);
}

void RuleWrapper::setSourceAddress(QString sourceAddress)
{
    if (m_rule.getSourceAddress().compare(sourceAddress) == 0)
        return;

    m_rule.setSourceAddress(sourceAddress);
    emit sourceAddressChanged(sourceAddress);
}

void RuleWrapper::setSourcePort(QString sourcePort)
{
    if (m_rule.getSourcePort().compare(sourcePort) == 0)
        return;

    m_rule.setSourcePort(sourcePort);
    emit sourcePortChanged(sourcePort);
}

void RuleWrapper::setDestinationAddress(QString destinationAddress)
{
    if (m_rule.getDestAddress().compare(destinationAddress)  == 0)
        return;

    m_rule.setDestAddress(destinationAddress);
    emit destinationAddressChanged(destinationAddress);
}

void RuleWrapper::setDestinationPort(QString destinationPort)
{
    if (m_rule.getDestPort().compare(destinationPort) == 0)
        return;

    m_rule.setDestPort(destinationPort);
    emit destinationPortChanged(destinationPort);
}

void RuleWrapper::setProtocol(int protocol)
{
    if (m_rule.getProtocol() == protocol)
        return;

    m_rule.setProtocol((UFW::Types::Protocol) protocol);
    emit protocolChanged(protocol);
}

void RuleWrapper::setInterface(QString interface)
{
    if (m_rule.getInterfaceIn().compare(interface) == 0)
        return;

    m_rule.setInterfaceIn(interface);
    emit interfaceChanged(interface);
}

void RuleWrapper::setLogging(QString logging)
{
    auto logging_t = UFW::Types::toLogging(logging);
    if (m_rule.getLogging() == logging_t)
        return;

    m_rule.setLogging(logging_t);
    emit loggingChanged(logging);
}

void RuleWrapper::setPosition(int position)
{
    if (m_rule.getPosition() == position)
        return;

    m_rule.setPosition(position);
    emit positionChanged(position);
}


