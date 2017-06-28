#include "nomadfirewallkcm.h"


#include <KAboutData>
#include <KLocalizedString>
#include <KPluginFactory>
#include <KAboutData>

#include "version.h"

K_PLUGIN_FACTORY_WITH_JSON(NomadFirewallKCMFactory,
                           "org.nxos.firewall-kcms-metadata.json",
                           registerPlugin<NomadFirewallKCM>(); )

K_EXPORT_PLUGIN(NomadFirewallKCMFactory("org.nxos.firewall" /* kcm name */, "org.nxos.firewall" /* catalog name */))

NomadFirewallKCM::NomadFirewallKCM(QObject *parent, const QVariantList &args) :
    KQuickAddons::ConfigModule(parent, args)
{
    KAboutData* about = new KAboutData("org.nxos.firewall", i18n("Configure Firewall"),
                                       "0.1", QString(), KAboutLicense::GPL_V3);
    about->addAuthor(i18n("Alexis López Zubieta"), QString(), "azubieta90@gmail.com");
    setAboutData(about);
    setButtons(Help | Apply | Default);
}

NomadFirewallKCM::~NomadFirewallKCM()
{

}

#include "nomadfirewallkcm.moc"
