#ifndef NOMADFIREWALLKCM_H
#define NOMADFIREWALLKCM_H


#include <KQuickAddons/ConfigModule>

class NomadFirewallKCM : public KQuickAddons::ConfigModule
{
    Q_OBJECT
public:
    explicit NomadFirewallKCM(QObject *parent, const QVariantList &args);

    ~NomadFirewallKCM();

};

#endif // NOMADFIREWALLKCM_H
