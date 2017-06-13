#include "nomadfirewallkcm.h"


#include <KAboutData>
#include <KDeclarative/KDeclarative>
#include <KLocalizedString>
#include <KPluginFactory>

#include "version.h"

K_PLUGIN_FACTORY_WITH_JSON(NomadFirewallKCMFactory,
                           "metadata.json",
                           registerPlugin<NomadFirewallKCM>(); )

NomadFirewallKCM::NomadFirewallKCM(QObject *parent, const QVariantList &args) :
    KQuickAddons::ConfigModule(parent, args)
{
    KAboutData *aboutData = new KAboutData("kcm_nomadFirewall",
                                           i18nc("@title", "Nomad Firewall"),
                                           global_s_versionStringFull,
                                           QStringLiteral(""),
                                           KAboutLicense::LicenseKey::GPL_V3,
                                           i18nc("@info:credit", "Copyright 2017 Alexis López Zubieta"));

    aboutData->addAuthor(i18nc("@info:credit", "Alexis López Zubieta"),
                        i18nc("@info:credit", "Author"),
                        QStringLiteral("azubieta90@gmail.com"));

    setAboutData(aboutData);
}

NomadFirewallKCM::~NomadFirewallKCM()
{

}

#include "nomadfirewallkcm.moc"
